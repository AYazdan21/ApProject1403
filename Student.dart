class Student {

    private String firstName;
    private String lastName;
    private String password;
    private int numberOfCourses;
    private int numberOfUnits;
    private List<Course> courses;
    private Map<Course, Double> grades;

    private static int count = 0;
    private int entryYear;
    private String code;
    private double totalAverage;
    private double currentAverage;

    Student (String firstName, String lastName, int entryYear, String password) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.grades = new HashMap<>();
        this.courses = new ArrayList<>();
        this.entryYear = entryYear;
        code = String.valueOf((entryYear) + String.valueOf(count));
        ++count;
    }  

}