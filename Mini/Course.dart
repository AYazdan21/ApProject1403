public class Course {

    private String name;
    private Teacher teacher;
    private int unit;
    private List<Student> students;
    private bool isActive;
    private int numberOfStudents;
    private List<Assignment> assignments;
    private int numberOfAssignments;
    private LocalDate ExamDate;

    Course(String name, Teacher teacher, int unit, bool isActive, LocalDate examDate) {
        this.name = name;
        this.teacher = teacher;
        this.unit = unit;
        this.isActive = isActive;
        this.ExamDate = examDate;
        assignments = new ArrayList<>();
        students = new ArrayList<>();
    }

}
