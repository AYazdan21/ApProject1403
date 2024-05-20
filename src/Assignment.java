import java.time.LocalDate;
import java.time.Period;

public class Assignment {

    private String name_assignment;
    private Course course;
    private LocalDate deadline;
    private boolean isActive_assignment;

    Assignment(String name, Course course, LocalDate deadline, boolean isActive_assignment) {
        this.name_assignment = name;
        this.course = course;
        this.deadline = deadline;
        this.isActive_assignment = isActive_assignment;
    }

    public void setDeadline(LocalDate deadline) {
        this.deadline = deadline;
    }

    public void setActive_assignment(boolean active_assignment) {
        isActive_assignment = active_assignment;
    }

    public void daysLeftToDeadline() {
        LocalDate today = LocalDate.now();
        Period period = Period.between(today, deadline);
        int daysLeft = period.getDays();
        System.out.println("Days left until the deadline: " + daysLeft);
    }

    public Course getCourse() {
        return course;
    }
}
