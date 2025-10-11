CREATE DATABASE IF NOT EXISTS university_records;
USE university_records;

CREATE USER IF NOT EXISTS 'shafi'@'%' IDENTIFIED BY 'Shafi123!';
GRANT ALL PRIVILEGES ON university_records.* TO 'shafi'@'%';
FLUSH PRIVILEGES;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Publications;
DROP TABLE IF EXISTS Research_Team_Members;
DROP TABLE IF EXISTS Committee_Members;
DROP TABLE IF EXISTS Course_Instructors;
DROP TABLE IF EXISTS Students_Organizations;
DROP TABLE IF EXISTS Course_Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Non_academic_staff;
DROP TABLE IF EXISTS Research_Projects;
DROP TABLE IF EXISTS Lecturers;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Committees;
DROP TABLE IF EXISTS Programs;
DROP TABLE IF EXISTS Departments;

CREATE TABLE IF NOT EXISTS Departments (
    Department_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Faculty VARCHAR(100) NOT NULL,
    Research_Areas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Programs (
    Program_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Degree_awarded VARCHAR(100) NOT NULL,
    Program_Duration TEXT,
    Course_Requirements TEXT,
    Enrollment_details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Committees (
    Committee_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Date_of_creation DATE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Courses (
    Course_ID INT AUTO_INCREMENT PRIMARY KEY,
    Course_Code VARCHAR(20) NOT NULL UNIQUE,
    Name VARCHAR(150) NOT NULL,
    Description TEXT,
    Department_ID INT,
    Level VARCHAR(20),
    Credits INT NOT NULL CHECK (credits > 0),
    Prerequisites TEXT,
    Schedule VARCHAR(100),
    Material TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Lecturers (
    Lecturer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Department_ID INT,
    Academic_Qualifications TEXT,
    Expertise TEXT,
    Course_load TEXT,
    Research_interests TEXT,
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Non_academic_staff (
    Staff_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Job_Title VARCHAR(100),
    Department_ID INT,
    Employment_type VARCHAR(100),
    Contact_details TEXT,
    Salary DECIMAL(12,2),
    Emergency_contact_info VARCHAR(255),
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Students (
    Student_id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Date_of_birth DATE NOT NULL,
    Contact_info VARCHAR(150),
    Program_id INT,
    Year_of_study INT CHECK (Year_of_study BETWEEN 1 AND 7),
    Current_Grades TEXT,
    Disciplinary_records TEXT,
    Graduation_status VARCHAR(20) DEFAULT 'Active',
    Advisor_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Program_id) REFERENCES Programs(Program_ID) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    FOREIGN KEY (Advisor_id) REFERENCES Lecturers(Lecturer_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Research_Projects (
    Project_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Principal_Investigator INT,
    Funding_sources TEXT,
    Outcomes TEXT,
    FOREIGN KEY (Principal_Investigator) REFERENCES Lecturers(Lecturer_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Course_Enrollments (
    Student_id INT NOT NULL,
    Course_id INT NOT NULL,
    Enrollment_date DATE DEFAULT (CURRENT_DATE),
    Semester VARCHAR(20),
    Academic_year VARCHAR(10),
    Status VARCHAR(20) DEFAULT 'Enrolled',
    PRIMARY KEY (Student_id, Course_id),
    FOREIGN KEY (Student_id) REFERENCES Students(Student_id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    FOREIGN KEY (Course_id) REFERENCES Courses(Course_ID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Students_Organizations (
    Organization_id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL UNIQUE,
    Description VARCHAR(255),
    Student_id INT,
    Join_date DATE DEFAULT (CURRENT_DATE),
    Role VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Student_id) REFERENCES Students(Student_id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Course_Instructors (
    Course_Instructor_ID INT AUTO_INCREMENT,
    Course_ID INT NOT NULL,
    Lecturer_ID INT NOT NULL,
    PRIMARY KEY (Lecturer_ID, Course_ID),
    UNIQUE KEY (Course_Instructor_ID),
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Lecturer_ID) REFERENCES Lecturers(Lecturer_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Committee_Members (
    Committee_Member_ID INT AUTO_INCREMENT PRIMARY KEY,
    Committee_ID INT NOT NULL,
    Lecturer_ID INT NOT NULL,
    Role VARCHAR(100),
    Start_Date DATE,
    End_Date DATE,
    FOREIGN KEY (Committee_ID) REFERENCES Committees(Committee_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Lecturer_ID) REFERENCES Lecturers(Lecturer_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Research_Team_Members (
    Project_ID INT NOT NULL,
    Lecturer_ID INT NOT NULL,
    PRIMARY KEY (Project_ID, Lecturer_ID),
    FOREIGN KEY (Project_ID) REFERENCES Research_Projects(Project_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Lecturer_ID) REFERENCES Lecturers(Lecturer_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Publications (
    Publication_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Publication_year INT,
    Publication_type VARCHAR(100),
    Lecturer_ID INT,
    Project_ID INT,
    FOREIGN KEY (Lecturer_ID) REFERENCES Lecturers(Lecturer_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (Project_ID) REFERENCES Research_Projects(Project_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ========================================

INSERT INTO Departments (Name, Faculty, Research_Areas) VALUES
('Computer Science', 'Science', 'Computer Science Research, Applied Computer Science'),
('Mathematics', 'Science', 'Mathematics Research, Applied Mathematics'),
('Physics', 'Science', 'Physics Research, Applied Physics'),
('Chemistry', 'Science', 'Chemistry Research, Applied Chemistry'),
('Biology', 'Science', 'Biology Research, Applied Biology'),
('Engineering', 'Engineering', 'Engineering Research, Applied Engineering'),
('Business', 'Business', 'Business Research, Applied Business'),
('Psychology', 'Arts', 'Psychology Research, Applied Psychology'),
('History', 'Arts', 'History Research, Applied History'),
('Literature', 'Arts', 'Literature Research, Applied Literature');

INSERT INTO Programs (Name, Degree_awarded, Program_Duration, Course_Requirements, Enrollment_details) VALUES
('Bachelor of Computer Science', 'BSc', '4 years', 'Complete all required courses', 'Open enrollment'),
('Master of Computer Science', 'MSc', '2 years', 'Complete all required courses', 'Open enrollment'),
('Bachelor of Engineering', 'BEng', '4 years', 'Complete all required courses', 'Open enrollment'),
('Master of Business Administration', 'MBA', '2 years', 'Complete all required courses', 'Open enrollment'),
('Bachelor of Science', 'BSc', '3 years', 'Complete all required courses', 'Open enrollment'),
('Doctor of Philosophy', 'PhD', '4-6 years', 'Complete all required courses', 'Open enrollment'),
('Bachelor of Arts', 'BA', '3 years', 'Complete all required courses', 'Open enrollment'),
('Master of Science', 'MSc', '1-2 years', 'Complete all required courses', 'Open enrollment');

INSERT INTO Committees (Name, Description, Date_of_creation) VALUES
('Academic Standards Committee', 'Responsible for academic standards committee', '2022-05-15'),
('Research Ethics Committee', 'Responsible for research ethics committee', '2020-01-20'),
('Curriculum Development Committee', 'Responsible for curriculum development committee', '2023-08-01'),
('Student Affairs Committee', 'Responsible for student affairs committee', '2019-11-05'),
('Faculty Hiring Committee', 'Responsible for faculty hiring committee', '2024-03-10');

INSERT INTO Lecturers (Name, Department_ID, Academic_Qualifications, Expertise, Course_load, Research_interests) VALUES
('Dr. Alan Turing', 1, 'PhD in Computer Science', 'Machine Learning, Artificial Intelligence', '3-4 courses per semester', 'Machine Learning'),
('Prof. Ada Lovelace', 6, 'PhD in Engineering', 'Software Engineering, Networks', '3-4 courses per semester', 'Software Engineering'),
('Dr. Isaac Newton', 2, 'PhD in Mathematics', 'Applied Mathematics, Quantum Computing', '3-4 courses per semester', 'Applied Mathematics');

INSERT INTO Courses (Course_Code, Name, Description, Department_ID, Level, Credits, Prerequisites, Schedule, Material)
VALUES
('CS101', 'Introduction to Programming', 'Covers basic programming concepts.', 1, 'Undergraduate', 3, 'None', 'MWF 10:00', 'Textbook and online resources'),
('MATH201', 'Calculus I', 'First course in differential calculus.', 2, 'Undergraduate', 4, 'None', 'TTh 11:00', 'Textbook and online resources'),
('ENG305', 'Software Engineering', 'Principles of software design and development.', 6, 'Undergraduate', 3, 'CS101', 'MWF 14:00', 'Textbook and online resources'),
('CS499', 'Advanced Algorithms', 'Topics in complex algorithm design.', 1, 'Graduate', 6, 'MATH201', 'TTh 09:00', 'Textbook and online resources'),
('LIT102', 'World Literature', 'Survey of major literary works.', 10, 'Undergraduate', 3, 'None', 'MWF 12:00', 'Textbook and online resources');

INSERT INTO Students (Name, Date_of_birth, Contact_info, Program_id, Year_of_study, Current_Grades, Disciplinary_records, Graduation_status, Advisor_id) VALUES
('Alice Smith', '2004-03-15', 'alice.s@uni.edu', 1, 1, '85, 92, 78, 65, 90', 'None', 'Active', 1),
('Bob Johnson', '2003-11-20', 'bob.j@uni.edu', 3, 2, '95, 88, 70, 91, 75', 'None', 'Active', 2),
('Charlie Brown', '2002-07-01', 'charlie.b@uni.edu', 5, 3, '77, 68, 89, 75, 82', 'None', 'Active', 3),
('Diana Prince', '2001-05-10', 'diana.p@uni.edu', 7, 4, '90, 90, 90, 90, 90', 'None', 'Graduated', 1),
('Eve Adams', '2005-01-25', 'eve.a@uni.edu', 1, 1, '62, 75, 80, 72, 65', 'None', 'Active', 2);

INSERT INTO Course_Enrollments (Student_id, Course_id, Enrollment_date, Semester, Academic_year, Status) VALUES
(1, 1, '2024-09-01', 'Fall 2024', '2024-2025', 'Enrolled'),
(2, 2, '2024-09-01', 'Fall 2024', '2024-2025', 'Enrolled'),
(3, 3, '2024-09-01', 'Fall 2024', '2024-2025', 'Enrolled'),
(4, 2, '2024-09-01', 'Fall 2024', '2024-2025', 'Enrolled'),
(5, 4, '2024-09-01', 'Fall 2024', '2024-2025', 'Enrolled');

INSERT INTO Course_Instructors (Course_ID, Lecturer_ID) VALUES
(1, 1),
(2, 3),
(3, 2),
(4, 1),
(5, 3);

INSERT INTO Research_Projects (Title, Principal_Investigator, Funding_sources, Outcomes) VALUES
('AI for Healthcare Diagnostics', 1, 'NSF Grant', 'Ongoing research'),
('Sustainable Engineering Materials', 2, 'Industry Partnership', 'Ongoing research'),
('Quantum Field Theory Applications', 3, 'University Fund', 'Ongoing research');

INSERT INTO Publications (Title, Publication_year, Publication_type, Lecturer_ID, Project_ID) VALUES
('Optimizing Neural Networks', 2024, 'Journal', 1, 1),
('Efficiency in Structural Design', 2025, 'Conference', 2, 2),
('New Methods in Calculus', 2023, 'Book Chapter', 3, NULL);

INSERT INTO Non_academic_staff (Name, Job_Title, Department_ID, Employment_type, Contact_details, Salary, Emergency_contact_info) VALUES
('Sarah Connor', 'Administrative Assistant', 1, 'Full-time', 'sarah.c@uni.edu', 55000.00, '555-1234'),
('John Smith', 'IT Support', 6, 'Full-time', 'john.s@uni.edu', 62000.00, '555-5678'),
('Jane Doe', 'Librarian', 9, 'Part-time', 'jane.d@uni.edu', 40000.00, '555-9012');

-- ----------------------------------------------------------------------

CREATE INDEX idx_lecturer_dept ON Lecturers (Department_ID);
CREATE INDEX idx_student_program ON Students (Program_id);
CREATE INDEX idx_student_advisor ON Students (Advisor_id);
CREATE INDEX idx_course_dept ON Courses (Department_ID);
CREATE INDEX idx_course_name ON Courses (Name);
CREATE INDEX idx_lecturer_expertise ON Lecturers (Expertise(255));
CREATE INDEX idx_lecturer_research ON Lecturers (Research_interests(255));

-- ----------------------------------------------------------------------

SELECT '--- DATABASE SETUP COMPLETE ---' AS Status_Message;
SELECT 'Tables created and data inserted.' AS Status_Message;

-- NIKUL QUERY 1: To find all courses taught by a specific instructor (Lecturer ID 1) 
-- and confirm they belong to their assigned department (Department ID 1).

SELECT 
    l.Name AS Lecturer_Name,
    c.Course_Code, 
    c.Name AS Course_Name
FROM Courses c
JOIN Course_Instructors ci ON c.Course_ID = ci.Course_ID
JOIN Lecturers l ON ci.Lecturer_ID = l.Lecturer_ID
WHERE l.Lecturer_ID = 1 AND l.Department_ID = 1;

-- NIKUL QUERY 2: To find all staff members employed in a specific department (Department ID 6 - Engineering).

SELECT 
    ns.Name, 
    ns.Job_Title,
    d.Name AS Department_Name
FROM Non_academic_staff ns
JOIN Departments d ON ns.Department_ID = d.Department_ID
WHERE d.Department_ID = 6;

-- NIKULQUERY 3: To identify students who are currently enrolled in a specific semester ('Fall 2024').

SELECT 
    s.Name,
    ce.Semester,
    ce.Status
FROM Students s
JOIN Course_Enrollments ce ON s.Student_id = ce.Student_id
WHERE ce.Semester = 'Fall 2024';

-- Chan Query 1: Find all students enrolled in a specific course taught by a particular lecturer
SELECT s.Name, s.Contact_info, c.Course_Code, c.Name as Course_Name, l.Name as Lecturer_Name
FROM Students s
JOIN Course_Enrollments ce ON s.Student_id = ce.Student_id
JOIN Courses c ON ce.Course_id = c.Course_ID
JOIN Course_Instructors ci ON c.Course_ID = ci.Course_ID
JOIN Lecturers l ON ci.Lecturer_ID = l.Lecturer_ID
WHERE c.Course_Code = 'CS101' AND l.Name LIKE '%Alan Turing%';

-- Chan Query 2: List all students with average grade above 70% who are in their final year
SELECT s.Name, p.Name as Program, s.Current_Grades, s.Year_of_study, s.Contact_info
FROM Students s
JOIN Programs p ON s.Program_id = p.Program_ID
WHERE s.Year_of_study = 4;

-- Chan Query 7: Identify lecturers who have supervised the most student research projects
SELECT l.Name, d.Name as Department, COUNT(rp.Project_ID) as Project_Count
FROM Lecturers l
JOIN Research_Projects rp ON l.Lecturer_ID = rp.Principal_Investigator
JOIN Departments d ON l.Department_ID = d.Department_ID
GROUP BY l.Lecturer_ID, l.Name, d.Name
ORDER BY Project_Count DESC
LIMIT 5;
