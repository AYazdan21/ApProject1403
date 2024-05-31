public class Assignment {

    private String name;
    private Course course;
    private LocalDate deadline;
    private bool isActive;

    Assignment (String name, Course course, LocalDate deadline, bool isActive) {
        this.name = name;
        this.course = course;
        this.deadline = deadline;
        this.isActive = isActive;
    }
    
}
