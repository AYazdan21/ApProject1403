# 🎓 Student Management System

A comprehensive full-stack student management application built with Java backend and Flutter frontend. This system provides role-based access for administrators, teachers, and students to manage courses, assignments, grades, and academic activities.

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Technologies](#technologies)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [Known Issues & Limitations](#known-issues--limitations)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)


<a id="features"></a>
## ✨ Features

### 👨‍💼 Administrator Features
- Add and remove teachers
- Create and manage courses
- Assign teachers to courses
- View system-wide statistics
- Manage user accounts

### 👨‍🏫 Teacher Features
- View assigned courses
- Create and manage assignments
- Grade student submissions
- Track student progress
- Post announcements and news
- Manage course materials

### 👨‍🎓 Student Features
- Enroll in courses
- View course materials and assignments
- Submit assignments
- Track grades and progress
- View personalized news feed
- Birthday notifications
- Task management (to-do list)

<a id="architecture"></a>
## 🏗️ Architecture

This project follows a **client-server architecture**:

- **Backend**: Java-based HTTP server handling business logic, data persistence, and API endpoints
- **Frontend**: Flutter mobile application providing cross-platform UI (Android/iOS)
- **Communication**: RESTful API with JSON data exchange
- **Data Storage**: File-based persistence system (text files)

```
┌─────────────────┐         HTTP/REST API        ┌──────────────────┐
│                 │ ◄──────────────────────────► │                  │
│  Flutter App    │         JSON Data            │   Java Server    │
│  (Frontend)     │                              │   (Backend)      │
│                 │                              │                  │
└─────────────────┘                              └──────────────────┘
                                                          │
                                                          ▼
                                                  ┌──────────────────┐
                                                  │   File Storage   │
                                                  │   (data/*.txt)   │
                                                  └──────────────────┘
```

<a id="technologies"></a>
## 🛠️ Technologies

### Backend
- **Language**: Java
- **Server**: Custom HTTP server implementation
- **Data Storage**: File-based (text files)
- **Architecture**: Object-oriented design with MVC pattern

### Frontend
- **Framework**: Flutter 3.3.3+
- **Language**: Dart
- **UI**: Material Design
- **State Management**: StatefulWidget
- **HTTP Client**: `http` package
- **Dependencies**:
  - `intl` - Internationalization and date formatting
  - `url_launcher` - Opening URLs
  - `file_picker` - File selection
  - `html` - HTML parsing
  - `confetti` - Celebration animations

<a id="prerequisites"></a>
## 📦 Prerequisites

### Backend Requirements
- Java Development Kit (JDK) 11 or higher
- IntelliJ IDEA (recommended) or any Java IDE
- Basic understanding of Java and HTTP protocols

### Frontend Requirements
- Flutter SDK 3.3.3 or higher
- Dart SDK (included with Flutter)
- Android Studio or VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development on macOS)

<a id="installation"></a>
## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/student-management-system.git
cd student-management-system
```

### 2. Backend Setup

```bash
cd backend

# Compile the Java project
javac -d out src/*.java

# Or open in IntelliJ IDEA and build the project
```

**Configure Data Directory:**
- Ensure the `data/` directory exists
- Sample data files will be created on first run
- Default server port: `8080` (configurable in `Server.java`)

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
flutter pub get

# Verify Flutter installation
flutter doctor

# Run on connected device/emulator
flutter run
```

**Configure Backend URL:**
- Open `lib/info.dart` or relevant configuration file
- Update the server URL to match your backend address:
  ```dart
  static const String baseUrl = 'http://localhost:8080';
  // For Android emulator: 'http://10.0.2.2:8080'
  // For physical device: 'http://YOUR_IP:8080'
  ```

<a id="usage"></a>
## 💻 Usage

### Starting the Backend Server

1. Navigate to the backend directory
2. Run the `Main.java` file:
   ```bash
   java -cp out Main
   ```
3. Choose your role:
   - Admin (1)
   - Teacher (2)
4. The server will start on `http://localhost:8080`

### Running the Frontend Application

1. Ensure the backend server is running
2. Start the Flutter app:
   ```bash
   cd frontend
   flutter run
   ```
3. On the login screen:
   - **Sign up** for a new account
   - **Login** with existing credentials
4. Navigate through the app based on your role

### Default Credentials (if applicable)
```
Admin:
  Username: admin
  Password: admin123

Teacher:
  Username: teacher1
  Password: teacher123

Student:
  Username: student1
  Password: student123
```

<a id="project-structure"></a>
## 📁 Project Structure

```
student-management-system/
│
├── backend/                          # Java Backend
│   ├── src/
│   │   ├── Main.java                # Entry point and CLI interface
│   │   ├── Server.java              # HTTP server implementation
│   │   ├── DB.java                  # Database/file operations
│   │   ├── Student.java             # Student model
│   │   ├── Teacher.java             # Teacher model
│   │   ├── Course.java              # Course model
│   │   └── Assignment.java          # Assignment model
│   ├── data/                        # Data storage
│   │   ├── studentsFile.txt
│   │   ├── teachersFile.txt
│   │   ├── courseFile.txt
│   │   ├── assignmentFile.txt
│   │   ├── birthday.txt
│   │   └── todoFile.txt
│   ├── Mini/                        # Dart model files (for reference)
│   ├── .gitignore
│   └── ApProject1403.iml
│
├── frontend/                         # Flutter Frontend
│   ├── lib/
│   │   ├── main.dart                # App entry point
│   │   ├── login_page.dart          # Login screen
│   │   ├── signup_page.dart         # Registration screen
│   │   ├── home_page.dart           # Home dashboard
│   │   ├── classes_page.dart        # Course listing
│   │   ├── tasks_page.dart          # Assignment/task management
│   │   ├── news_page.dart           # News feed
│   │   ├── birthday_page.dart       # Birthday notifications
│   │   ├── news_handler.dart        # News data handling
│   │   ├── info.dart                # Configuration and constants
│   │   └── theme.dart               # App theming
│   ├── images/                      # Image assets
│   ├── android/                     # Android-specific configuration
│   ├── test/                        # Unit tests
│   ├── pubspec.yaml                 # Flutter dependencies
│   ├── analysis_options.yaml        # Dart linting rules
│   └── .gitignore
│
├── README.md                         # This file
└── .gitignore                       # Root gitignore
```

<a id="testing"></a>
## 🧪 Testing

### Backend Testing
```bash
cd backend
# Run unit tests (if implemented)
java -cp out:junit.jar org.junit.runner.JUnitCore TestSuite
```

### Frontend Testing
```bash
cd frontend
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

<a id="known-issues--limitations"></a>
## 🚧 Known Issues & Limitations

- File-based storage (not suitable for production; consider migrating to a database)
- No authentication token expiration
- Limited error handling in some edge cases
- No real-time updates (requires manual refresh)
- Single-threaded server (may not handle high concurrency)

<a id="future-enhancements"></a>
## 🔮 Future Enhancements

- [ ] Migrate to PostgreSQL/MySQL database
- [ ] Implement JWT-based authentication
- [ ] Add real-time notifications using WebSockets
- [ ] Implement file upload for assignments
- [ ] Add video conferencing integration
- [ ] Create admin dashboard with analytics
- [ ] Implement email notifications
- [ ] Add multi-language support
- [ ] Create web version using Flutter Web
- [ ] Implement automated testing suite
- [ ] Add Docker containerization
- [ ] Create CI/CD pipeline

<a id="contributing"></a>
## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards
- **Java**: Follow Oracle Java Code Conventions
- **Dart/Flutter**: Follow official Dart style guide
- Write meaningful commit messages
- Add comments for complex logic
- Update documentation for new features

<a id="license"></a>
## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

<a id="authors"></a>
## 👥 Authors

- **Amirreza Yazdanpanah** 
- **Aryan Pira**

<a id="acknowledgments"></a>
## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Java community for extensive documentation
- All contributors and testers

<a id="contact"></a>
## 📞 Contact

For questions or support, please contact:
- Email: a.yazdanpanah1383@gmail.com
- GitHub: [@AYazdan21](https://github.com/AYazdan21)
- LinkedIn: [Amirreza Yazdanpanah](https://www.linkedin.com/in/amirreza-yazdanpanah-69459a297/)


---

**⭐ If you find this project helpful, please consider giving it a star!**

---

*Last Updated: May 2025*
