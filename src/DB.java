import java.io.*;
import java.util.*;
import java.time.LocalDateTime;

public class DB {
    public static String DBPath = "C:\\Users\\Amirreza Yazdanpanah\\Desktop\\ApProject1403\\data\\";

    public static void clearTempFile() {
        try {
            File temp = new File(DBPath + "temp.txt");
            PrintWriter writer = new PrintWriter(temp);
            writer.close();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static boolean checkTeacherInFile(String TID) throws Exception {
        try {
            File file = new File(DBPath + "teachersFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(TID)) {
                    return true;
                }
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
        return false;
    }

    public static boolean checkCourseInFile(String Cname) throws Exception {
        try {
            File file = new File(DBPath + "courseFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(Cname)) {
                    return true;
                }
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
        return false;
    }

    public static boolean checkAssignmentInFile(String AName, String Cname) throws Exception {
        try {
            File file = new File(DBPath + "assignmentFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if (info[0].equals(AName)) {
                    if (info[1].equals(Cname)) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
        return false;
    }

    public static boolean checkStudentInFile(String StudentID) {
        try {
            File file = new File(DBPath + "studentsFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(StudentID)) {
                    return true;
                }
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
        return false;
    }

    public static boolean checkCourseInStudent(String Cname, String StudentID) {
        try {
            File file = new File(DBPath + "studentsFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;
            String[] courseGrade;
            String[] course;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if (info[0].equals(StudentID)) {
                    if (!info[1].equals("")) {
                        courseGrade = info[1].split("-");
                        for (int i = 0; i < courseGrade.length; i++) {
                            course = courseGrade[i].split("/");
                            if (course[0].equals(Cname)) {
                                return true;
                            }
                        }
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
        return false;
    }

//    public static boolean checkStudentInCourse(String Cname, String StudentID) {
//        try {
//            File file = new File(DBPath + "courseFile.txt");
//            FileInputStream fis = new FileInputStream(file);
//            BufferedReader br = new BufferedReader(new InputStreamReader(fis));
//
//            String line;
//            String[] info;
//            String[] students;
//
//            while ((line = br.readLine()) != null) {
//                info = line.split("\\$");
//                if (info[0].equals(Cname)) {
//                    if (!info[5].equals("")) {
//                        students = info[5].split("/");
//                        for (int i = 0; i < students.length; i++) {
//                            if (students[i].equals(StudentID)) {
//                                return true;
//                            }
//                        }
//                    }
//                    return false;
//                }
//
//            }
//        } catch (IOException e) {
//            System.err.println("Error: " + e.getMessage());
//        }
//        return false;
//    }

    public static boolean checkCourseHasTeacher(String Cname) {
        try {
            File file = new File(DBPath + "courseFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(Cname)) {
                    if(!info[1].equals("")) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
        return false;
    }

    public static boolean checkTeacherHasCourse(String TID) {
        try {
            File file = new File(DBPath + "teachersFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;
            String[] courses;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(TID)) {
                    if (!info[1].equals("")) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        } catch (ArrayIndexOutOfBoundsException e) {
            System.err.println();
        }
        return false;
    }

    public static void saveTeacherToCourse(String Cname, String TID) { // strictly for courses that don't have teachers
        try {
            File file = new File(DBPath + "courseFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(Cname)) {
                    if (info[1].equals("")) {
                        int firstDollarIndex = line.indexOf('$');
                        int secondDollarIndex = line.indexOf('$', firstDollarIndex + 1);
                        line = info[0] + "$" + TID + line.substring(secondDollarIndex);
                    }
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }

            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br2 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br2.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "courseFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void deleteTeacherFromCourse(String Cname) {
        try {
            File file = new File(DBPath + "courseFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(Cname)) {
                    if (!info[1].equals("")) {
                        line = info[0] + "$$" + info[2] + "$" + info[3] + "$" + info[4]; /*+ "$"+ info[5];*/
                    }
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }

            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br2 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br2.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "courseFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void removeTeacherFromAllCourses(String TID) {
        try {
            File file = new File(DBPath + "courseFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[1].equals(TID)) {
                    line = info[0] + "$$" + info[2] + "$" + info[3] + "$" + info[4]; /*+ "$" + info[5];*/
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }

            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br2 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br2.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "courseFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        } catch (ArrayIndexOutOfBoundsException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void deleteTeacherFromFile(String TID) {
        try {
            File file = new File(DBPath + "teachersFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(TID)) {
                    continue;
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();

            }

            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br2 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br2.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "teachersFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }
    public static void saveCourseToTeacher(String TID, String Cname) {
        try {
            File file = new File(DBPath + "teachersFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(TID)) {
                    if (info[1].equals("")) {
                        line = info[0] + "$" + Cname + "$" + info[2] + "$" + info[3];
                    }
                    else {
                        line = info[0] + "$" + info[1] + "/" + Cname + "$" + info[2] + "$" + info[3];
                    }
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }

            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br3.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "teachersFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Course added to Teacher successfully!");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void saveCourseToStudent(String StudentID, String Cname, String grade) {
        try {
            File file = new File(DBPath + "studentsFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if (info[0].equals(StudentID)) {
                    if(info[1].equals("")) {
                        line = info[0] + "$" + Cname + "/" + grade + "$" + info[2] + "$" + info[3];
                    }
                    else {
                        line = info[0] + "$" + info[1] + "-" + Cname + "/" + grade + "$" + info[2] + "$" + info[3];
                    }
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br3.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "studentsFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Course added to Student successfully!");

        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void changeIsActiveInCourse(String Cname, String isActive) {
        try {
            File file = new File(DBPath + "courseFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if (info[0].equals(Cname)) {
                        line = info[0] + "$" + info[1] + "$" + info[2] + "$" + isActive + "$" + info[4];
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br3.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "courseFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Change successful!");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void saveCourseToFile(String Cname, String TID, String Vaheds, String isActive, String examDate/*, String Students*/) {
        try {
            FileWriter fileWriter = new FileWriter(DBPath + "courseFile.txt", true);
            fileWriter.write('\n');
            fileWriter.write(Cname + "$" + TID + "$" + Vaheds + "$" + isActive + "$" + examDate /* + "$" + Students*/ );
            fileWriter.close();
            System.out.println("Course saved to file successfully!");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void saveAssignmentToFile(String Aname, String Cname, String deadline, String isActive) {
        try {
            FileWriter fileWriter = new FileWriter(DBPath + "assignmentFile.txt", true);
            fileWriter.write('\n');
            fileWriter.write(Aname + "$" + Cname + "$" + deadline + "$" + isActive);
            fileWriter.close();
            System.out.println("Assignment saved to file successfully!");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void saveStudentToFile(String StudentID, String courses, String Fname, String Lname) {
        try {
            FileWriter fileWriter = new FileWriter(DBPath + "studentsFile.txt", true);
            fileWriter.write('\n');
            fileWriter.write(StudentID + "$" + courses + "$" + Fname + "$" + Lname);
            fileWriter.close();
            System.out.println("Student saved to file successfully");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void saveTeacherToFile(String TID, String fName, String lName, String Courses) {
        try {
            FileWriter fileWriter = new FileWriter(DBPath + "teachersFile.txt", true);
            fileWriter.write('\n');
            fileWriter.write(TID + "$" + Courses + "$" + fName + "$" + lName);
            fileWriter.close();
            System.out.println("Teacher saved to file successfully");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void removeCourseFromTeacherFile(String Cname) {
        try {
            File file = new File(DBPath + "teachersFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;
            String[] courses;


            while ((line = br.readLine()) != null) {
                int courseIndex = -1;
                info = line.split("\\$");
                if (!info[1].equals("")) {
                    courses = info[1].split("/");
                    for (int i = 0; i < courses.length; i++) {
                        if(courses[i].equals(Cname)) {
                            courseIndex = i;
                        }
                    }
                    if (courseIndex != -1) {
                        StringBuilder tempCourses1 = new StringBuilder();
                        StringBuilder tempCourses2 = new StringBuilder();
                        for (int i = 0; i < courseIndex; i++) {
                            if (i != courseIndex - 1) {
                                tempCourses1.append(courses[i]).append("/");
                            }
                            else {
                                tempCourses1.append(courses[i]);
                            }

                        }
                        for (int i = courseIndex + 1; i < courses.length; i++) {
                            if (i == courseIndex + 1) {
                                tempCourses2.append("/").append(courses[i]).append("/");
                            }
                            else if(i != courses.length - 1) {
                                tempCourses2.append(courses[i]).append("/");
                            }
                            else {
                                tempCourses2.append(courses[i]);
                            }
                        }
                        line = info[0] + "$" + tempCourses1 + tempCourses2 + "$" + info[2] + "$" + info[3];
                    }

                }

                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br3.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "teachersFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Course removed from Teachers successfully!");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        } catch (ArrayIndexOutOfBoundsException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void removeCourseFromStudentFile(String Cname) {
        try {
            File file = new File(DBPath + "studentsFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;
            String[] courseGrade;
            int courseGradeIndex = -1;
            String[] course;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if (!info[1].equals("")) {
                    courseGrade = info[1].split("-");
                    for (int i = 0; i < courseGrade.length; i++) {
                        course = courseGrade[i].split("/");
                        if (course[0].equals(Cname)) {
                            courseGradeIndex = i;
                            break;
                        }
                    }
                    StringBuilder tempCoursesGrade1 = new StringBuilder();
                    StringBuilder tempCoursesGrade2 = new StringBuilder();
                    for (int i = 0; i < courseGradeIndex; i++) {
                        tempCoursesGrade1.append(courseGrade[i]).append("-");
                    }
                    for (int i = courseGradeIndex + 1; i < courseGrade.length; i++) {
                        if (i != courseGrade.length - 1) {
                            tempCoursesGrade2.append(courseGrade[i]).append("-");
                        }
                        else {
                            tempCoursesGrade2.append(courseGrade[i]);
                        }
                    }
                    line = info[0] + "$" + tempCoursesGrade1 + tempCoursesGrade2 + "$" + info[2] + "$" + info[3];
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br3.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "studentsFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Course removed from Students successfully!");

        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void removeCourseFromStudent(String StudentID, String Cname) {
        try {
            File file = new File(DBPath + "studentsFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;
            String[] courseGrade;
            int courseGradeIndex = -1;
            String[] course;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if (info[0].equals(StudentID)) {
                    if (!info[1].equals("")) {
                        courseGrade = info[1].split("-");
                        for (int i = 0; i < courseGrade.length; i++) {
                            course = courseGrade[i].split("/");
                            if (course[0].equals(Cname)) {
                                courseGradeIndex = i;
                                break;
                            }
                        }
                        StringBuilder tempCoursesGrade1 = new StringBuilder();
                        StringBuilder tempCoursesGrade2 = new StringBuilder();
                        for (int i = 0; i < courseGradeIndex; i++) {
                            tempCoursesGrade1.append(courseGrade[i]).append("-");
                        }
                        for (int i = courseGradeIndex + 1; i < courseGrade.length; i++) {
                            if (i != courseGrade.length - 1) {
                                tempCoursesGrade2.append(courseGrade[i]).append("-");
                            }
                            else {
                                tempCoursesGrade2.append(courseGrade[i]);
                            }
                        }
                        line = info[0] + "$" + tempCoursesGrade1 + tempCoursesGrade2 + "$" + info[2] + "$" + info[3];
                    }
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br3.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "studentsFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Course removed from Student successfully!");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

//    public static void removeStudentFromCourse(String Cname, String StudentID) {
//        try {
//            File file = new File(DBPath + "courseFile.txt");
//            FileInputStream fis = new FileInputStream(file);
//            BufferedReader br = new BufferedReader(new InputStreamReader(fis));
//
//            String line;
//            String[] info;
//            String[] students;
//            int studentIndex = -1;
//
//            while ((line = br.readLine()) != null) {
//                info = line.split("\\$");
//                if (info[0].equals(Cname)) {
//                    if (!info[5].equals("")) {
//                        students = info[5].split("/");
//                        for (int i = 0; i < students.length; i++) {
//                            if (students[i].equals(StudentID)) {
//                                studentIndex = i;
//                                break;
//                            }
//                        }
//                        StringBuilder tempStudent1 = new StringBuilder();
//                        StringBuilder tempStudent2 = new StringBuilder();
//                        for (int i = 0; i < studentIndex; i++) {
//                            tempStudent1.append(students[i]).append("/");
//                        }
//                        for (int i = studentIndex + 1; i < students.length; i++) {
//                            if (i != students.length - 1) {
//                                tempStudent2.append(students[i]).append("/");
//                            }
//                            else {
//                                tempStudent2.append(students[i]);
//                            }
//                        }
//                        line = info[0] + "$" + info[1] + "$" + info[2] + "$" + info[3] + "$" + info[4] + "$" + tempStudent1 + tempStudent2;
//                    }
//                }
//                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
//                fileWriter.write(line + '\n');
//                fileWriter.close();
//
//            }
//            PrintWriter writer = new PrintWriter(file);
//            writer.close();
//
//            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
//            while ((line = br3.readLine()) != null) {
//                FileWriter fileWriter = new FileWriter(DBPath + "courseFile.txt", true);
//                fileWriter.write(line + '\n');
//                fileWriter.close();
//            }
//            clearTempFile();
//            System.out.println("Course removed from Student successfully!");
//        } catch (IOException e) {
//            System.err.println("Error: " + e.getMessage());
//        }
//    }

    public static void deleteCourseAssignments(String Cname) {
        try {
            File file = new File(DBPath + "assignmentFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if (info[1].equals(Cname)) {
                    continue;
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br3 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br3.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "assignmentFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Course's assignments removed successfully!");

        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void deleteStudentFromFile(String StudentID) {
        try {
            File file = new File(DBPath + "studentsFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(StudentID)) {
                    continue;
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br2 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br2.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "studentsFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void deleteAssignmentFromFile(String Aname, String Cname) {
        try {
            File file = new File(DBPath + "assignmentFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(Aname)) {
                    if (info[1].equals(Cname)) {
                        continue;
                    }
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br2 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br2.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "assignmentFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
            System.out.println("Assignment removed from file successfully!");
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }

    public static void deleteCourseFromFile(String Cname) {
        try {
            File file = new File(DBPath + "courseFile.txt");
            FileInputStream fis = new FileInputStream(file);
            BufferedReader br = new BufferedReader(new InputStreamReader(fis));

            String line;
            String[] info;

            while ((line = br.readLine()) != null) {
                info = line.split("\\$");
                if(info[0].equals(Cname)) {
                    continue;
                }
                FileWriter fileWriter = new FileWriter(DBPath + "temp.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();

            }

            PrintWriter writer = new PrintWriter(file);
            writer.close();

            BufferedReader br2 = new BufferedReader(new FileReader(DBPath + "temp.txt"));
            while ((line = br2.readLine()) != null) {
                FileWriter fileWriter = new FileWriter(DBPath + "courseFile.txt", true);
                fileWriter.write(line + '\n');
                fileWriter.close();
            }
            clearTempFile();
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }


}
