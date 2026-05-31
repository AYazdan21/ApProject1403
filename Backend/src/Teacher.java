import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Teacher {

    private String teacherID; //***
    private String firstname;
    private String surname;
    private List<Course> coursesTaught;

    private int numberOfCourses;

    Teacher(String firstname, String surname, String teacherID) {
        this.firstname = firstname;
        this.surname = surname;
        this.teacherID = teacherID;
        coursesTaught = new ArrayList<>();
        numberOfCourses = coursesTaught.size();

    }


    public void addCourseTaught(Course course) {
        coursesTaught.add(course);
    }

    public void addStudentToCourse(Course course, Student student) {
        if (coursesTaught.contains(course)) {
            course.addStudent(student);
        }
    }


    public void removeStudentFromCourse(Course course, Student student) {
        if (coursesTaught.contains(course)) {
            course.removeStudent(student);
        }
    }


    public void changeAssignmentDeadline(Assignment assignment, LocalDate deadline) {
        if(assignment.getCourse().getTeacher() == this) {
            assignment.setDeadline(deadline);
        }
    }

    public void gradeStudent(Student student, Course course, double grade) {
        if (course.getTeacher() == this) {
            student.setGrade(course, grade);
        } else {
            System.out.println("Teacher does not teach this course!");
        }
    }

}
