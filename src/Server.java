import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.io.*;
import java.net.*;

class Server {
    public static void main(String[] args) throws IOException {
        System.out.println("Welcome to the Server!");
        ServerSocket serverSocket = new ServerSocket(8412);
        while (true) {
            System.out.println("Waiting for Client...");
            new ClientHandler(serverSocket.accept()).start();
        }
    }
}

class ClientHandler extends Thread {
    Socket socket;
    DataOutputStream dos;
    DataInputStream dis;
    //

    public ClientHandler(Socket socket) throws IOException {
        this.socket = socket;
        dos = new DataOutputStream(socket.getOutputStream());
        dis = new DataInputStream(socket.getInputStream());
        System.out.println("Connected to Server!");
    }

    public String listener() throws IOException {
        System.out.println("listener is activated!");
        StringBuilder sb = new StringBuilder();
        int index = dis.read();
        while (index != 0) {
            sb.append((char) index);
            index = dis.read();
        }
        System.out.println("listener -> command read successfully");
        return sb.toString();
    }

    //send the response to server
    public void writer(String write) throws IOException {
        dos.writeBytes(write);
        dos.flush();
        dos.close();
        dis.close();
        System.out.println(write);
        System.out.println("command finished and response sent to server");

    }

    @Override
    public synchronized void run() {
        super.run();
        String command;

        try {
            command = listener();
            System.out.println("Command received: { " + command + " }");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        String[] split = command.split("~");
        for (String s : split) {
            System.out.println(s);
        }

//        String[][] courseUnit;

        switch (split[0]) {
            case "login": {
                //3 --> ID: correct & Password: correct --> login successful
                //2 --> ID: correct & Password: incorrect --> incorrect password
                //1 --> ID: incorrect & Password: correct --> incorrect ID
                //login~stuID~password --> format of message
                boolean logedIn = false;
                int responseOfDatabase = 0;

                responseOfDatabase = DB.studentLogIn(split[1], split[2]);

                if (responseOfDatabase == 3) {
                    logedIn = true;
                    System.out.println("status code is 200");
                    System.out.println("Successfully logged in!");
                    try {
                        writer("200");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                else if (responseOfDatabase == 2) {
                    logedIn = false;
                    System.out.println("status code is 401");
                    System.out.println("Password is incorrect");
                    try {
                        writer("401");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                else if (responseOfDatabase == 1) {
                    logedIn = false;
                    System.out.println("status code is 404");
                    System.out.println("Student Number is incorrect");
                    try {
                        writer("404");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;
            }

            case "signUp": {
                //2 --> signup successful
                //1 --> signup failed --> already exists
                //signUp~firstname~surname~stuID~password
                boolean signupCompleted = false;
                boolean checkStudentExists = false;

                checkStudentExists = DB.checkStudentInFile(split[3]);

                if (checkStudentExists) {
                    System.out.println("status code is 1");
                    System.out.println("signUp failed... Student already exists");
                    try {
                        writer("1");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                else {
                    DB.saveStudentToFile(split[3], split[4], "", split[1], split[2]);
                    System.out.println("status code is 2");
                    System.out.println("signUp successful");
                    try {
                        writer("2");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;
            }
            case "name": {
                //info~stuID
                String fullname = DB.getStudentFLname(split[1]);
                System.out.println("found student name");
                try {
                    writer(fullname);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            }
            case "unitGrades": {
                //unitGrades~stuID
                int numUnits = 0;
                double sum = 0;
                String studentCourses = DB.getCoursesFromStudent(split[1]);
                if (studentCourses != null) {
                    String[] coursesSeparate = studentCourses.split("-");
                    String[][] courseidUnit = new String[coursesSeparate.length][2];
                    for (int i = 0; i < coursesSeparate.length; i++) {
                        String[] courseGrade = coursesSeparate[i].split("/");
                        courseidUnit[i][0] = courseGrade[0];
                        courseidUnit[i][1] = DB.getUnitsFromCourse(courseidUnit[i][0]);
                        if (courseidUnit[i][1] != null) {
                            numUnits += Integer.parseInt(courseidUnit[i][1]);
                            sum += Double.parseDouble(courseGrade[1]) * Integer.parseInt(courseidUnit[i][1]);
                        }
                    }
                    double grade = sum / numUnits;
                    System.out.println("calculated number of units");
                    System.out.println("calculated grade");
                    try {
                        writer(String.valueOf(numUnits) + "-" + grade);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("student doesn't have any courses");
                }
                break;
            }
            case "home": {
                //home~stuID
                double highestGrade = 0;
                double lowestGrade = 0;
                int upcomingExams = 0;
                int tasksRemaining = 0;
                int missedDeadlines = 0;
                String studentCourses = DB.getCoursesFromStudent(split[1]);
                double max = -1;
                double min = 21;
                if (studentCourses != null) {
                    String[] coursesSeparate = studentCourses.split("-");
                    for (int i = 0; i < coursesSeparate.length; i++) {
                        String[] courseGrade = coursesSeparate[i].split("/");
                        String cid = courseGrade[0];
                        tasksRemaining += DB.getNumOfRemainingAssignmentsForCourse(cid);
                        missedDeadlines += DB.getNumOfMissedAssignmentsForCourse(cid);
                        String cExamDate = DB.getExamDateFromCourse(cid);
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                        try {
                            LocalDate examDate = LocalDate.parse(cExamDate, formatter);
                            LocalDate today = LocalDate.now();
                            if (examDate.isAfter(today)) {
                                upcomingExams++;
                            }
                        } catch (DateTimeParseException e) {
                            e.printStackTrace();
                        }

                        if (Double.parseDouble(courseGrade[1]) > max) {
                            max = Double.parseDouble(courseGrade[1]);
                        }
                        if (Double.parseDouble(courseGrade[1]) < min) {
                            min = Double.parseDouble(courseGrade[1]);
                        }
                    }
                    highestGrade = max;
                    lowestGrade = min;
                    try {
                        writer(String.valueOf(highestGrade) + "-" + String.valueOf(lowestGrade) + "-" + String.valueOf(upcomingExams) + "-" + String.valueOf(tasksRemaining) + "-" + String.valueOf(missedDeadlines));
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("student doesn't have any courses to assess");
                    try {
                        writer("0-0-0-0-0");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;

            }
            case "deleteAccount": {
                //deleteAccount~stuID
                DB.deleteStudentFromFile(split[1]);
                try {
                    writer("account deleted");
                } catch (IOException e) {
                    e.printStackTrace();
                }

                break;
            }
            case "class": {
                //class~stuID
                String studentCourses = DB.getCoursesFromStudent(split[1]);
                if (studentCourses != null) {
                    String[] coursesSeparate = studentCourses.split("-");
                    String[][] courseidUnit = new String[coursesSeparate.length][2]; /////////
                    //courseUnit[][0] == course id    courseUnit[][1] == number of units
                    String[] cTeacherID = new String[courseidUnit.length];
                    String[] cTeacherName = new String[courseidUnit.length];
                    String[] cName = new String[courseidUnit.length];
                    int[] cRemainingTasks = new int[courseidUnit.length];

                    for (int i = 0; i < coursesSeparate.length; i++) {
                        String[] courseGrade = coursesSeparate[i].split("/");
                        courseidUnit[i][0] = courseGrade[0];
                        courseidUnit[i][1] = DB.getUnitsFromCourse(courseidUnit[i][0]);
                        cName[i] = DB.getCourseNameFromFile(courseidUnit[i][0]);
                        cTeacherID[i] = DB.getTeacherFromCourseFile(courseidUnit[i][0]);
                        cTeacherName[i] = DB.getTeacherFullnameFromFile(cTeacherID[i]); /////////
                        cRemainingTasks[i] = DB.getNumOfActiveAssignmentForCourse(courseidUnit[i][0]);
                    }

                    String[] cTopStudent = new String[courseidUnit.length];
                    for (int i = 0; i < coursesSeparate.length; i++) {
                        Map<String, Double> studentGrade = new HashMap<>(DB.listOfStudentsWithCourse(courseidUnit[i][0]));
                        String maxKey = null;
                        double max = -1;
                        for (Map.Entry<String, Double> entry : studentGrade.entrySet()) {
                            if (entry.getValue() > max) {
                                max = entry.getValue();
                                maxKey = entry.getKey();
                            }
                        }
                        cTopStudent[i] = DB.getStudentFLname(maxKey);
                    }
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < courseidUnit.length; i++) {
                        sb.append(cName[i]).append("/").append(cTeacherName[i]).append("/").append(courseidUnit[i][1]).append("/").append(cRemainingTasks[i]).append("/").append(cTopStudent[i]);
                        if (i != courseidUnit.length - 1) {
                            sb.append("-");
                        }
                    }
                    try {
                        writer(sb.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;
            }
            case "tasks": {
                //tasks~stuID
                String studentCourses = DB.getCoursesFromStudent(split[1]);
                StringBuilder sb = new StringBuilder();
                if (studentCourses != null) {
                    String[] coursesSeparate = studentCourses.split("-");
                    for (int i = 0; i < coursesSeparate.length; i++) {
                        String[] courseGrade = coursesSeparate[i].split("/");
                        String cid = courseGrade[0];
                        sb.append(DB.getAssignmentDataForCourse(cid));
                    }
                    if (sb.length() > 0 && sb.charAt(sb.length() - 1) == ',') {
                        sb.deleteCharAt(sb.length() - 1);
                    }
                    try {
                        writer(sb.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

                break;
            }
            case "taskChange": {
                //taskChange~stuID~assignmentName
                String[] aNameCName = split[2].split(" - ");
                String aName = aNameCName[0];
                String cName = aNameCName[1];
                String cid = DB.getCourseIDfromName(cName);
                DB.changeIsActiveInAssignment(aName, cid);
                try {
                    writer("changed isActive");
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            }
            case "classAddCourse": {
                //classAddCourse~stuID~cid
                if (DB.checkCourseInFile(split[2])) {
                    if (!DB.checkCourseInStudent(split[2], split[1])) {
                        DB.saveCourseToStudent(split[1], split[2], "00.00");
                        String cName = DB.getCourseNameFromFile(split[2]);
                        String cTeacherID = DB.getTeacherFromCourseFile(split[2]);
                        String cTeacherName = DB.getTeacherFullnameFromFile(cTeacherID);
                        String cUnits = DB.getUnitsFromCourse(split[2]);
                        int cRemainingTasks = DB.getNumOfActiveAssignmentForCourse(split[2]);
                        String cTopStudent;
                        Map<String, Double> studentGrade = new HashMap<>(DB.listOfStudentsWithCourse(split[2]));
                        String maxKey = null;
                        double max = -1;
                        for (Map.Entry<String, Double> entry : studentGrade.entrySet()) {
                            if (entry.getValue() > max) {
                                max = entry.getValue();
                                maxKey = entry.getKey();
                            }
                        }
                        cTopStudent = DB.getStudentFLname(maxKey);
                        StringBuilder sb = new StringBuilder();
                        sb.append(cName).append("/").append(cTeacherName).append("/").append(cUnits).append("/").append(cRemainingTasks).append("/").append(cTopStudent);
                        try {
                            writer(sb.toString());
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    } else {
                        System.out.println("student already enrolled in course");
                        try {
                            writer("1");
                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                    }
                } else {
                    System.out.println("course doesn't exist");
                    try {
                        writer("0");
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;
            }
            case "birthday": {
                //birthday~stuID
                StringBuilder sb = DB.getBirthdaysToday();
                if (sb.length() > 0 && sb.charAt(sb.length() - 1) == ',') {
                    sb.deleteCharAt(sb.length() - 1);
                }
                try {
                    writer(sb.toString());
                } catch (IOException e) {
                    e.printStackTrace();
                }
                break;
            }
            case "todos": {
                //todos~stuID
                String data = DB.getStudentTodos(split[1]);
                if (data != null) {
                    try {
                        writer(data);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                break;
            }
            case "updateTodo": {
                //updateTodo~taskName~status~stuID
                DB.updateStudentTodo(split[3], split[1], split[2]);
                System.out.println("update complete for todo");
                break;
            }
            case "deleteTodo": {
                //deleteTodo~taskName~stuID
                DB.deleteTodo(split[2], split[1]);
                System.out.println("delete complete for todo");
                break;
            }
            case "addTodo": {
                //addTodo~taskTitle~date~time~stuID
                DB.addTodoToStudent(split[4], split[1], split[2], split[3]);
                System.out.println("todo added");
                break;
            }





        }
    }
}
