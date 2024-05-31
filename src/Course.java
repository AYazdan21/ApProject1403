import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Arrays;
public class Course {

    private String name;
    private Teacher teacher;
    private int vaheds;
    private List<Student> students;
    private boolean isActive;
    private int numberOfStudents;
    private List<Assignment> assignments;
    private int numberOfAssignments;
    private LocalDate ExamDate;

    //active projects



    Course(String name, Teacher teacher, int vaheds, boolean isActive, LocalDate examDate) {
        this.name = name;
        this.teacher = teacher;
        this.vaheds = vaheds;
        this.isActive = isActive;
        this.ExamDate = examDate;
        assignments = new ArrayList<>();
        students = new ArrayList<>();
    }

    public void printStudentsEnrolled() {
        for (Student student : students) {
            System.out.println(student);
        }
    }

    public void addStudent(Student s) {

        if (!students.contains(s)) {
            students.add(s);
            s.getCourses().add(this);
            s.setNumberOfCourses(s.getNumberOfCourses() + 1);
            s.setNumberOfVahed(s.getNumberOfVahed() + this.vaheds);
        }
    }

    public void removeStudent(Student s) {
        if (students.remove(s)) {
            s.getCourses().remove(this);
            s.setNumberOfCourses(s.getNumberOfCourses() - 1);
            s.setNumberOfVahed(s.getNumberOfVahed() - this.vaheds);
        }
    }

    public String getName() {
        return name;
    }

    public double findHighestGrade() {
        double highestGrade = -1.0;

        for (Student student : students) {
            double grade = student.getGradeForCourse(this);
            if (grade > highestGrade) {
                highestGrade = grade;
            }
        }

        return highestGrade;
    }

    public Teacher getTeacher() {
        return teacher;
    }

    public List<Student> getStudents() {
        return students;
    }

    public void setStudents(List<Student> students) {
        this.students = students;
    }

    public int getVaheds() {
        return vaheds;
    }
}