import java.sql.SQLOutput;
import java.util.Map;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) throws Exception {

        Scanner input = new Scanner(System.in);
        boolean running = true;


        System.out.println("What is your role? \nAdmin (1)      Teacher (2)");
        int roleNum = input.nextInt();
        System.out.print("\033[H\033[2J");
        System.out.flush();

        boolean isAdmin = false;

        if (roleNum == 1) {
            System.out.println("Welcome to the Admins page!\n Choose what to do:\n");
            isAdmin = true;

            while (running) {
                System.out.print("""
                        1. Add a new Teacher
                        2. Remove a Teacher
                        3. Add a new Course
                        4. Remove a Course
                        5. set a teacher for a course
                        6. remove Teacher from a Course
                        7. Add a Student to a Course
                        8. Remove a Student from a Course
                        9. Add a new Student
                        10. Remove a Student
                        11. Add an Assignment to a Course
                        12. Remove an Assignment from a Course
                        13. Make Course active/inactive
                        14. quit
                        """);
                int choice1_admin = input.nextInt();
                switch (choice1_admin) {
                    case 1:
                        System.out.println("Enter new Teacher's full name:");
                        String TFname1 = input.next();
                        String TLname1 = input.next();
                        System.out.println("Enter an ID for this Teacher:");
                        String TID1 = input.next();
                        if (!DB.checkTeacherInFile(TID1)) {
                            System.out.println("Do you want to set this Teacher for a course?\nYes (1)  No (2)");
                            int choiceAdd1 = input.nextInt();
                            if (choiceAdd1 == 1) {
                                System.out.println("Enter Course name:");
                                String Cname1 = input.next();
                                if (DB.checkCourseInFile(Cname1)) {
                                    if (DB.checkCourseHasTeacher(Cname1)) {
                                        System.out.println("This Course already has a Teacher. If you want to set a new Teacher, remove the old one first.");
                                    } else {
                                        DB.saveTeacherToFile(TID1, TFname1, TLname1, Cname1);
                                        DB.saveTeacherToCourse(Cname1, TID1);
                                        System.out.println("Teacher set to Course successfully");
                                    }
                                }
                                else {
                                    System.out.println("Course doesn't exist. No Course set for Teacher.");
                                }

                            } else if (choiceAdd1 == 2) {
                                DB.saveTeacherToFile(TID1, TFname1, TLname1, "");
                            }
                        } else {
                            System.out.println("Teacher already exists!");
                        }
                        break;
                    case 2:
                        System.out.println("Enter Teacher's ID");
                        String TID2 = input.next();
                        if (DB.checkTeacherInFile(TID2)) {
                            if (DB.checkTeacherHasCourse(TID2)) {
                                DB.removeTeacherFromAllCourses(TID2);
                            }
                            DB.deleteTeacherFromFile(TID2);
                            System.out.println("Teacher removed successfully!");
                        } else {
                            System.out.println("Teacher with this ID doesn't exist");
                        }
                        break;
                    case 3:
                        System.out.println("Enter a name for this course");
                        String Cname3 = input.next();
                        if (DB.checkCourseInFile(Cname3)) {
                            System.out.println("Course already exists!");
                        }
                        else {
                            System.out.println("Set a Teacher for this Course:");
                            System.out.println("Enter Teacher ID:");
                            String TID3 = input.next();
                            int status3 = 1;
                            while (!DB.checkTeacherInFile(TID3)) {
                                System.out.println("Teacher with this ID doesn't exist.\nTry with a different ID (1)   quit (2)");
                                int choice3 = input.nextInt();
                                if (choice3 == 1) {
                                    status3 = 1;
                                    TID3 = input.next();
                                }
                                else if (choice3 == 2) {
                                    status3 = 2;
                                    System.out.println("Failed to create Course because no Teacher was chosen.");
                                    break;
                                }
                            }
                            if (status3 == 1 && DB.checkTeacherInFile(TID3)) {
                                System.out.println("Enter number of Vaheds for this course:");
                                String Cvahed3 = input.next();
                                System.out.println("Is this Course active?\nYes (1)  No (0)");
                                String CisActive3 = input.next();
                                System.out.println("Enter Course exam date:");
                                String CexamDate3 = input.next();
                                DB.saveCourseToFile(Cname3, TID3, Cvahed3, CisActive3, CexamDate3 /*, null*/);
                                DB.saveCourseToTeacher(TID3, Cname3);
                            }

                        }
                        break;
                    case 4:
                        System.out.println("Enter name of the Course to be removed:");
                        String Cname4 = input.next();
                        if (!DB.checkCourseInFile(Cname4)) {
                            System.out.println("Course doesn't exist!");
                        } else {
                            DB.removeCourseFromTeacherFile(Cname4);
                            DB.removeCourseFromStudentFile(Cname4);
                            DB.deleteCourseAssignments(Cname4);
                            DB.deleteCourseFromFile(Cname4);
                            System.out.println("Course removed successfully!");
                        }
                        break;
                    case 5:
                        System.out.println("Enter Course name:");
                        String Cname5 = input.next();
                        if (DB.checkCourseHasTeacher(Cname5)) {
                            System.out.println("This Course already has a Teacher. If you want to set a new Teacher, remove the old one first.");
                        } else {
                            System.out.println("Enter Teacher ID:");
                            String TID5 = input.next();
                            if (DB.checkTeacherInFile(TID5)) {
                                DB.saveTeacherToCourse(Cname5, TID5);
                                DB.saveCourseToTeacher(TID5, Cname5);
                                System.out.println("Teacher set to Course successfully");
                            }
                            else {
                                int status5 = 0;
                                while (!DB.checkTeacherInFile(TID5)) {
                                    System.out.println("Teacher with this ID doesn't exist.\nTry with a different ID (1)   quit (2)");
                                    int choice5 = input.nextInt();
                                    if (choice5 == 1) {
                                        status5 = 1;
                                        TID5 = input.next();
                                    }
                                    else if (choice5 == 2) {
                                        status5 = 2;
                                        System.out.println("Failed to create Course because no Teacher was chosen.");
                                        break;
                                    }
                                }
                                if (status5 == 1 && DB.checkTeacherInFile(TID5)) {
                                    DB.saveTeacherToCourse(Cname5, TID5);
                                    DB.saveCourseToTeacher(TID5, Cname5);
                                    System.out.println("Teacher set to Course successfully");
                                }
                            }

                        }
                        break;
                    case 6:
                        System.out.println("Enter Course name:");
                        String Cname6 = input.next();
                        if (!DB.checkCourseInFile(Cname6)) {
                            System.out.println("Course doesn't exist!");
                        } else {
                            if (!DB.checkCourseHasTeacher(Cname6)) {
                                System.out.println("Course doesn't have a Teacher!");
                            } else {
                                DB.deleteTeacherFromCourse(Cname6);
                                System.out.println("Teacher removed from Course successfully!");
                            }
                        }
                        break;
                    case 7:
                        System.out.println("Enter Student ID:");
                        String StudentID7 = input.next();
                        if (!DB.checkStudentInFile(StudentID7)) {
                            System.out.println("Student doesn't exist!");
                        } else {
                            System.out.println("Enter Course name:");
                            String Cname7 = input.next();
                            if (!DB.checkCourseInFile(Cname7)) {
                                System.out.println("Course doesn't exist");
                            } else {
                                if (DB.checkCourseInStudent(Cname7, StudentID7)) {
                                    System.out.println("Student is already enrolled in this Course!");
                                } else {
                                    DB.saveCourseToStudent(StudentID7, Cname7, "0");
                                    System.out.println("Student added to Course successfully!");
                                }
                            }
                        }
                        break;
                    case 8:
                        System.out.println("Enter Student ID:");
                        String StudentID8 = input.next();
                        if (!DB.checkStudentInFile(StudentID8)) {
                            System.out.println("Student doesn't exist!");
                        } else {
                            System.out.println("Enter Course name:");
                            String Cname8 = input.next();
                            if (!DB.checkCourseInFile(Cname8)) {
                                System.out.println("Course doesn't exist");
                            } else {
                                if (!DB.checkCourseInStudent(Cname8, StudentID8)) {
                                    System.out.println("Student isn't enrolled in this Course.");
                                } else {
                                    DB.removeCourseFromStudent(StudentID8, Cname8);
                                    System.out.println("Student removed from Course successfully!");
                                }
                            }
                        }
                        break;
                    case 9:
                        System.out.println("Enter Student's full name:");
                        String SFname9 = input.next();
                        String SLname9 = input.next();
                        System.out.println("Enter Student ID:");
                        String StudentID9 = input.next();
                        if (DB.checkStudentInFile(StudentID9)) {
                            System.out.println("Student already exists!");
                        } else {
                            DB.saveStudentToFile(StudentID9, "", SFname9, SLname9);
                        }
                        break;
                    case 10:
                        System.out.println("Enter Student ID:");
                        String StudentID10 = input.next();
                        if (DB.checkStudentInFile(StudentID10)) {
                            DB.deleteStudentFromFile(StudentID10);
                        } else {
                            System.out.println("Student doesn't exist!");
                        }
                        break;
                    case 11:
                        System.out.println("Enter Assignment Name:");
                        String AName11 = input.next();
                        System.out.println("Enter Course Name");
                        String Cname11 = input.next();
                        if (DB.checkAssignmentInFile(AName11, Cname11)) {
                            System.out.println("Assignment already exists!");
                        } else {
                            System.out.println("Enter deadline date:");
                            String deadline11 = input.next();
                            System.out.println("is Assignment active?\nYes (1)  no (0)");
                            String isActive11 = input.next();
                            DB.saveAssignmentToFile(AName11, Cname11, deadline11, isActive11);
                        }
                        break;
                    case 12:
                        System.out.println("Enter Assignment name:");
                        String Aname12 = input.next();
                        System.out.println("Enter Course name:");
                        String Cname12 = input.next();
                        if (!DB.checkAssignmentInFile(Aname12, Cname12)) {
                            System.out.println("Assignment doesn't exist!");
                        } else {
                            DB.deleteAssignmentFromFile(Aname12, Cname12);
                        }
                        break;
                    case 13:
                        System.out.println("Enter Course Name:");
                        String Cname13 = input.next();
                        if (!DB.checkCourseInFile(Cname13)) {
                            System.out.println("Course doesn't exist!");
                        } else {
                            System.out.println("Set Course as\nActive (1)  Inactive(0)");
                            String isActive13 = input.next();
                            DB.changeIsActiveInCourse(Cname13, isActive13);
                        }
                        break;

                    case 14:
                        running = false;
                        break;


                }
            }


        } else if (roleNum == 2) {
            System.out.println("Enter Teacher ID:");
            String TID = input.next();
            if (DB.checkTeacherInFile(TID)) {
                System.out.println("Welcome to the Teachers page!");

                while (running) {
                    System.out.print("""
                        1. Add Student to Course
                        2. Remove Student from Course
                        3. Grade Student ////////////////
                        4. Add Assignment to Course
                        5. Remove Assignment from Course
                        6. Change Assignment Deadline
                        7. quit
                        """);

                    int choice1_teacher = input.nextInt();
                    switch (choice1_teacher) {
                        case 1:
                            System.out.println("Enter Student ID:");
                            String StudentID1 = input.next();
                            if (DB.checkStudentInFile(StudentID1)) {
                                System.out.println("Enter Course name:");
                                String Cname1 = input.next();
                                if (DB.checkCourseInFile(Cname1)) {
                                    if (DB.checkTeacherInCourse(Cname1, TID)) {
                                        DB.saveCourseToStudent(StudentID1, Cname1, "0");
                                    } else {
                                        System.out.println("You don't have access to this Course!");
                                    }
                                } else {
                                    System.out.println("Course doesn't exist!");
                                }
                            } else {
                                System.out.println("Student doesn't exist!");
                            }
                            break;
                        case 2:
                            System.out.println("Enter Student ID:");
                            String StudentID2 = input.next();
                            if (!DB.checkStudentInFile(StudentID2)) {
                                System.out.println("Student doesn't exist!");
                            } else {
                                System.out.println("Enter Course name:");
                                String Cname2 = input.next();
                                if (!DB.checkCourseInFile(Cname2)) {
                                    System.out.println("Course doesn't exist");
                                } else {
                                    if(DB.checkTeacherInCourse(Cname2, TID)) {
                                        if (!DB.checkCourseInStudent(Cname2, StudentID2)) {
                                            System.out.println("Student isn't enrolled in this Course.");
                                        } else {
                                            DB.removeCourseFromStudent(StudentID2, Cname2);
                                            System.out.println("Student removed from Course successfully!");
                                        }
                                    } else {
                                        System.out.println("You don't have access to this Course");
                                    }

                                }
                            }
                            break;
                        case 3:
                            System.out.println("Enter Course name:");
                            String Cname3 = input.next();
                            if (DB.checkCourseInFile(Cname3)) {
                                if (DB.checkTeacherInCourse(Cname3, TID)) {
                                    System.out.println("Enter Student ID");
                                    String StudentID3 = input.next();
                                    if (DB.checkStudentInFile(StudentID3)) {
                                        if (DB.checkCourseInStudent(Cname3, StudentID3)) {
                                            System.out.println("Enter grade:");
                                            String grade = input.next();
                                            //////////////////////////////////////////////
                                        } else {
                                            System.out.println("Student isn't enrolled in this Course!");
                                        }
                                    } else {
                                        System.out.println("Student doesn't exist!");
                                    }
                                } else {
                                    System.out.println("You don't have access to this Course!");
                                }
                            } else {
                                System.out.println("Course doesn't exist!");
                            }
                            break;
                        case 4:
                            System.out.println("Enter Assignment Name:");
                            String AName4 = input.next();
                            System.out.println("Enter Course Name");
                            String Cname4 = input.next();
                            if (DB.checkTeacherInCourse(Cname4, TID)) {
                                if (DB.checkAssignmentInFile(AName4, Cname4)) {
                                    System.out.println("Assignment already exists!");
                                } else {
                                    System.out.println("Enter deadline date:");
                                    String deadline11 = input.next();
                                    System.out.println("is Assignment active?\nYes (1)  no (0)");
                                    String isActive11 = input.next();
                                    DB.saveAssignmentToFile(AName4, Cname4, deadline11, isActive11);
                                }
                            } else {
                                System.out.println("You don't have access to this course");
                            }
                            break;
                        case 5:
                            System.out.println("Enter Assignment name:");
                            String Aname5 = input.next();
                            System.out.println("Enter Course name:");
                            String Cname5 = input.next();
                            if (DB.checkTeacherInCourse(Cname5, TID)) {
                                if (!DB.checkAssignmentInFile(Aname5, Cname5)) {
                                    System.out.println("Assignment doesn't exist!");
                                } else {
                                    DB.deleteAssignmentFromFile(Aname5, Cname5);
                                }
                            } else {
                                System.out.println("You don't have access to this Course!");
                            }
                            break;
                        case 6:
                            System.out.println("Enter Assignment name:");
                            String Aname6 = input.next();
                            System.out.println("Enter Course name:");
                            String Cname6 = input.next();
                            if (DB.checkTeacherInCourse(Cname6, TID)) {
                                if (!DB.checkAssignmentInFile(Aname6, Cname6)) {
                                    System.out.println("Assignment doesn't exist!");
                                } else {
                                    System.out.println("Enter new Date:");
                                    String deadline = input.next();
                                    DB.changeAssignmentDeadline(Aname6, Cname6, deadline);
                                }
                            } else {
                                System.out.println("You don't have access to this Course!");
                            }
                            break;
                        case 7:
                            running = false;
                            break;

                    }
                }
            } else {
                System.out.println("Teacher with this ID isn't registered in the System. Please Try again later.");
            }


        }
    }


}
