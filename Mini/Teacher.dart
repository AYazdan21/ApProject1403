class Teacher {

    private String firstname;
    private String lastName;
    private String code;
    private String password;
    private int numberOfCourses;
    private List<Course> courses;

    Teacher (String firstName, String lastName, String code, String password) {
        this.firstname = firstName;
        this.lastName = lastName;
        this.code = code;
        this.password = password;
        courses = new ArrayList<>();
    }

}
