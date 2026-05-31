import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Student {

    private int numberOfCourses;
    private int numberOfVahed;

    private List<Course> courses;
    private Map<Course, Double> grades;

    private double gradeThisSemester;
    private String firstName;
    private String lastName;
    private String studentID;


    Student(String StudentID, String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.studentID = StudentID;
        this.grades = new HashMap<>();
        this.numberOfCourses = 0;
        this.numberOfVahed = 0;
        this.courses = new ArrayList<>();

    }

    public void enrollCourse(Course course) {

        courses.add(course);
        course.addStudent(this);
        grades.put(course, null);
        numberOfCourses++;
        numberOfVahed += course.getVaheds();
    }

    public double getGradeForCourse(Course course) {
        return grades.getOrDefault(course, -1.0);
    }

    public void setGrade(Course course, double grade) {
        if (courses.contains(course)) {
            grades.put(course, grade);
        } else {
            System.out.println("Student is not enrolled in this course!");
        }
    }

    public Map<Course, Double> getGrades() {
        return grades;
    }

    public double getGradeThisSemester() {
        return gradeThisSemester;
    }

    void printCourses() {
        for (Course course : courses) {
            System.out.println(course);
        }
    }
    void printNumberOfVahed() {
        System.out.println(numberOfVahed);
    }

    public List<Course> getCourses() {
        return courses;
    }

    private int calculateTotalVahed() {
        int totalVahed = 0;
        for (Course course : courses) {
            totalVahed += course.getVaheds();
        }
        return totalVahed;
    }

    public void setCourses(List<Course> courses) {
        this.courses = courses;
        this.numberOfCourses = courses.size();
        this.numberOfVahed = calculateTotalVahed();
    }

    public void setNumberOfCourses(int numberOfCourses) {
        this.numberOfCourses = numberOfCourses;
    }

    public void setNumberOfVahed(int numberOfVahed) {
        this.numberOfVahed = numberOfVahed;
    }

    public int getNumberOfCourses() {
        return numberOfCourses;
    }

    public int getNumberOfVahed() {
        return numberOfVahed;
    }
}
