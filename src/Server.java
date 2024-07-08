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
            case "units": {
                //units~stuID
                int numUnits = 0;
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
                        }
                    }

                    System.out.println("calculated number of units");
                    try {
                        writer(String.valueOf(numUnits));
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("student doesn't have any courses");
                }
                break;
            }
//            case "grade": {
//                //grade~stuID
//
//
//                break;
//            }
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

        }
    }
}
