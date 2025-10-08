-- UNIVERSITY RECORDS DATABASE SETUP
-- STEP 1: DATABASE CREATION
CREATE DATABASE IF NOT EXISTS university_records;
USE university_records;

-- STEP 2: TABLE CREATION 

-- Departments: Foundation for academic structure
CREATE TABLE IF NOT EXISTS Departments (
    Department_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Faculty VARCHAR(100) NOT NULL,
    Research_Areas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Programs: Degree programs offered
CREATE TABLE IF NOT EXISTS Programs (
    Program_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Degree_awarded VARCHAR(100) NOT NULL,
    Program_Duration TEXT,
    Course_Requirements TEXT,
    Enrollment_details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Committees: Administrative and academic committees
CREATE TABLE IF NOT EXISTS Committees (
    Committee_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Date_of_creation DATE
) ENGINE=InnoDB;

-- LEVEL 2 TABLES (DEPEND ON DEPARTMENTS)

-- Courses: Academic courses offered
CREATE TABLE IF NOT EXISTS Courses (
    Course_ID INT AUTO_INCREMENT PRIMARY KEY,
    Course_Code VARCHAR(20) NOT NULL UNIQUE,
    Name VARCHAR(150) NOT NULL,
    Description TEXT,
    Department_ID INT,
    Level VARCHAR(20),
    Credits INT  NOT NULL CHECK (Credits > 0),
    Prerequisites TEXT,
    Schedule VARCHAR(100),
    Material TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Lecturers: Faculty members
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

-- Non_academic_staff: Support staff
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

-- LEVEL 3 TABLES (DEPEND ON LECTURERS AND PROGRAMS)

-- Students: Student records
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

-- Research_Projects: Research initiatives
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

-- LEVEL 4 TABLES (JUNCTION/ASSOCIATION TABLES)

-- Course_Enrollments: Links students to courses
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

-- Students_Organizations: Student org memberships
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

-- Course_Instructors: Links lecturers to courses
CREATE TABLE IF NOT EXISTS Course_Instructors (
    Course_Instructor_ID INT AUTO_INCREMENT,
    Course_ID INT NOT NULL,
    Lecturer_ID INT NOT NULL,
    PRIMARY KEY (Lecturer_ID, Course_ID), -- composite primary key 
    UNIQUE KEY (Course_Instructor_ID),
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Lecturer_ID) REFERENCES Lecturers(Lecturer_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Committee_Members: Links lecturers to committees
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

-- Research_Team_Members: Links lecturers to research projects
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

-- Publications: Research publications
CREATE TABLE IF NOT EXISTS Publications (
    Publication_ID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Publication_year YEAR,
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

-- ========================================
-- STEP 4: VERIFICATION
-- ========================================

-- Display all tables created
SELECT '=== TABLES CREATED ===' AS 'STATUS';
SHOW TABLES;

-- Count tables created
SELECT '=== TABLE COUNT ===' AS 'STATUS';
SELECT COUNT(*) AS 'Total Tables Created' 
FROM information_schema.tables 
WHERE table_schema = 'university_records';

-- View columns for all tables using the university records schema
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_DEFAULT,
    EXTRA
FROM information_schema.columns
WHERE table_schema = 'university_records'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Add Advisor_id column to Students table
USE university_records;

-- Add the Advisor_id column
ALTER TABLE Students 
ADD COLUMN Advisor_id INT NULL AFTER Graduation_status;

-- Add foreign key constraint to reference Lecturers table
ALTER TABLE Students
ADD CONSTRAINT fk_student_advisor 
FOREIGN KEY (Advisor_id) REFERENCES Lecturers(Lecturer_ID)
    ON DELETE SET NULL
    ON UPDATE CASCADE;

-- Verify the column was added
DESCRIBE Students;

-- Optional: Show the table structure with foreign keys
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_DEFAULT,
    EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'university_records' 
    AND TABLE_NAME = 'Students'
ORDER BY ORDINAL_POSITION;

SELECT '=== Advisor_id column added successfully ===' AS Status;

describe Students;