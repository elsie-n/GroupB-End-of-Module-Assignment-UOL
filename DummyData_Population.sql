-- UNIVERSITY RECORDS DATABASE - DUMMY DATA POPULATION
-- This script populates the database with realistic test data
-- NO TABLE ALTERATIONS - Only INSERT statements

USE university_records;

-- Disable foreign key checks for easier insertion
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data (optional - comment out if you want to keep existing data)
TRUNCATE TABLE Publications;
TRUNCATE TABLE Research_Team_Members;
TRUNCATE TABLE Committee_Members;
TRUNCATE TABLE Course_Instructors;
TRUNCATE TABLE Students_Organizations;
TRUNCATE TABLE Course_Enrollments;
TRUNCATE TABLE Research_Projects;
TRUNCATE TABLE Students;
TRUNCATE TABLE Non_academic_staff;
TRUNCATE TABLE Lecturers;
TRUNCATE TABLE Courses;
TRUNCATE TABLE Committees;
TRUNCATE TABLE Programs;
TRUNCATE TABLE Departments;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- LEVEL 1: DEPARTMENTS, PROGRAMS, COMMITTEES
-- ========================================

-- Insert Departments
INSERT INTO Departments (Name, Faculty, Research_Areas) VALUES
('Computer Science', 'Faculty of Science and Technology', 'Artificial Intelligence, Machine Learning, Cybersecurity, Software Engineering'),
('Mathematics', 'Faculty of Science and Technology', 'Applied Mathematics, Statistics, Pure Mathematics, Computational Mathematics'),
('Physics', 'Faculty of Science and Technology', 'Quantum Physics, Astrophysics, Particle Physics, Applied Physics'),
('Chemistry', 'Faculty of Science and Technology', 'Organic Chemistry, Inorganic Chemistry, Physical Chemistry, Biochemistry'),
('Biology', 'Faculty of Science and Technology', 'Molecular Biology, Ecology, Genetics, Microbiology'),
('English Literature', 'Faculty of Arts and Humanities', 'Modern Literature, Shakespeare Studies, Creative Writing, Literary Theory'),
('History', 'Faculty of Arts and Humanities', 'Modern History, Ancient History, Social History, Economic History'),
('Economics', 'Faculty of Social Sciences', 'Microeconomics, Macroeconomics, Development Economics, Econometrics'),
('Psychology', 'Faculty of Social Sciences', 'Clinical Psychology, Cognitive Psychology, Developmental Psychology, Social Psychology'),
('Business Administration', 'Faculty of Business', 'Management, Marketing, Finance, Entrepreneurship');

-- Insert Programs
INSERT INTO Programs (Name, Degree_awarded, Program_Duration, Course_Requirements, Enrollment_details) VALUES
('Bachelor of Science in Computer Science', 'BSc', '4 years (8 semesters)', '120 credits minimum, including core CS courses and electives', 'Fall and Spring intake, minimum GPA 3.0'),
('Bachelor of Science in Mathematics', 'BSc', '4 years (8 semesters)', '120 credits minimum, including calculus sequence and advanced mathematics', 'Fall and Spring intake, minimum GPA 2.8'),
('Bachelor of Arts in English Literature', 'BA', '3 years (6 semesters)', '90 credits minimum, including survey courses and period specializations', 'Fall intake only'),
('Bachelor of Science in Physics', 'BSc', '4 years (8 semesters)', '120 credits minimum, including laboratory courses', 'Fall and Spring intake'),
('Master of Science in Computer Science', 'MSc', '2 years (4 semesters)', '30 credits minimum, thesis required', 'Fall intake, BSc in CS or related field required'),
('Bachelor of Business Administration', 'BBA', '4 years (8 semesters)', '120 credits minimum, including internship requirement', 'Fall and Spring intake'),
('Master of Business Administration', 'MBA', '2 years (4 semesters)', '60 credits minimum, capstone project required', 'Fall intake, 2 years work experience preferred'),
('Bachelor of Science in Psychology', 'BSc', '4 years (8 semesters)', '120 credits minimum, including research methods and statistics', 'Fall and Spring intake'),
('PhD in Physics', 'PhD', '4-6 years', 'Dissertation required, comprehensive exams', 'Fall intake only, MSc required'),
('Bachelor of Arts in History', 'BA', '3 years (6 semesters)', '90 credits minimum, including historical methods course', 'Fall and Spring intake');

-- Insert Committees
INSERT INTO Committees (Name, Description, Date_of_creation) VALUES
('Academic Standards Committee', 'Oversees academic policies and curriculum development', '2015-01-15'),
('Research Ethics Committee', 'Reviews and approves research proposals involving human subjects', '2014-06-01'),
('Student Affairs Committee', 'Handles student welfare and disciplinary matters', '2015-09-01'),
('Faculty Development Committee', 'Promotes professional development of faculty members', '2016-03-15'),
('Library Committee', 'Manages library resources and policies', '2015-01-20'),
('Admissions Committee', 'Reviews and decides on student admissions', '2014-08-01'),
('Budget and Finance Committee', 'Oversees university budget and financial planning', '2015-02-01'),
('Technology Infrastructure Committee', 'Plans and manages IT infrastructure', '2017-01-10');

-- ========================================
-- LEVEL 2: COURSES, LECTURERS, NON-ACADEMIC STAFF
-- ========================================

-- Insert Courses
INSERT INTO Courses (Course_Code, Name, Description, Department_ID, Level, Credits, Prerequisites, Schedule, Material) VALUES
-- Computer Science Courses
('CS101', 'Introduction to Programming', 'Fundamental programming concepts using Python', 1, 'Undergraduate', 4, 'None', 'MWF 9:00-10:00 AM', 'Python Programming textbook, online IDE'),
('CS201', 'Data Structures and Algorithms', 'Study of fundamental data structures and algorithms', 1, 'Undergraduate', 4, 'CS101', 'TTh 11:00-12:30 PM', 'Algorithm Design Manual'),
('CS301', 'Database Systems', 'Relational database design and SQL', 1, 'Undergraduate', 3, 'CS201', 'MWF 2:00-3:00 PM', 'Database Systems textbook, MySQL'),
('CS401', 'Machine Learning', 'Introduction to ML algorithms and applications', 1, 'Undergraduate', 4, 'CS201, MATH201', 'TTh 2:00-3:30 PM', 'Pattern Recognition and ML textbook'),
('CS501', 'Advanced Artificial Intelligence', 'Deep learning and neural networks', 1, 'Graduate', 3, 'CS401', 'W 6:00-9:00 PM', 'Deep Learning textbook, TensorFlow'),

-- Mathematics Courses
('MATH101', 'Calculus I', 'Limits, derivatives, and basic integration', 2, 'Undergraduate', 4, 'None', 'MWF 10:00-11:00 AM', 'Stewart Calculus textbook'),
('MATH201', 'Linear Algebra', 'Vector spaces, matrices, and linear transformations', 2, 'Undergraduate', 4, 'MATH101', 'TTh 9:30-11:00 AM', 'Linear Algebra and Its Applications'),
('MATH301', 'Real Analysis', 'Rigorous study of real numbers and functions', 2, 'Undergraduate', 3, 'MATH201', 'MWF 1:00-2:00 PM', 'Principles of Mathematical Analysis'),
('MATH401', 'Abstract Algebra', 'Groups, rings, and fields', 2, 'Undergraduate', 3, 'MATH201', 'TTh 3:00-4:30 PM', 'Abstract Algebra textbook'),

-- Physics Courses
('PHYS101', 'General Physics I', 'Mechanics and thermodynamics', 3, 'Undergraduate', 4, 'MATH101', 'MWF 11:00-12:00 PM, Lab: T 2:00-5:00 PM', 'University Physics textbook'),
('PHYS201', 'General Physics II', 'Electricity, magnetism, and optics', 3, 'Undergraduate', 4, 'PHYS101', 'MWF 1:00-2:00 PM, Lab: Th 2:00-5:00 PM', 'University Physics Vol 2'),
('PHYS301', 'Quantum Mechanics I', 'Introduction to quantum theory', 3, 'Undergraduate', 4, 'PHYS201, MATH201', 'TTh 10:00-11:30 AM', 'Introduction to Quantum Mechanics'),
('PHYS501', 'Advanced Quantum Mechanics', 'Advanced topics in quantum theory', 3, 'Graduate', 3, 'PHYS301', 'MW 4:00-5:30 PM', 'Modern Quantum Mechanics'),

-- English Literature Courses
('ENG101', 'Introduction to Literature', 'Survey of major literary works and genres', 6, 'Undergraduate', 3, 'None', 'TTh 9:00-10:30 AM', 'Norton Anthology of Literature'),
('ENG201', 'Shakespeare', 'Study of major plays and sonnets', 6, 'Undergraduate', 3, 'ENG101', 'MWF 10:00-11:00 AM', 'Complete Works of Shakespeare'),
('ENG301', 'Modern British Literature', 'British literature from 1900 to present', 6, 'Undergraduate', 3, 'ENG101', 'TTh 2:00-3:30 PM', 'Norton Anthology Modern British Lit'),

-- Business Courses
('BUS101', 'Introduction to Business', 'Overview of business principles and practices', 10, 'Undergraduate', 3, 'None', 'MWF 9:00-10:00 AM', 'Business Essentials textbook'),
('BUS201', 'Financial Accounting', 'Principles of financial accounting', 10, 'Undergraduate', 3, 'BUS101', 'TTh 11:00-12:30 PM', 'Financial Accounting textbook'),
('BUS301', 'Marketing Management', 'Marketing strategies and consumer behavior', 10, 'Undergraduate', 3, 'BUS101', 'MWF 2:00-3:00 PM', 'Marketing Management textbook'),
('BUS401', 'Strategic Management', 'Business strategy and competitive analysis', 10, 'Undergraduate', 3, 'BUS201, BUS301', 'TTh 3:30-5:00 PM', 'Strategic Management textbook'),

-- Psychology Courses
('PSY101', 'Introduction to Psychology', 'Overview of psychological principles', 9, 'Undergraduate', 3, 'None', 'MWF 11:00-12:00 PM', 'Psychology: Themes and Variations'),
('PSY201', 'Research Methods in Psychology', 'Statistical methods and research design', 9, 'Undergraduate', 4, 'PSY101, MATH101', 'TTh 1:00-2:30 PM', 'Research Methods textbook, SPSS'),
('PSY301', 'Cognitive Psychology', 'Study of mental processes', 9, 'Undergraduate', 3, 'PSY101', 'MWF 3:00-4:00 PM', 'Cognitive Psychology textbook');

-- Insert Lecturers
INSERT INTO Lecturers (Name, Department_ID, Academic_Qualifications, Expertise, Course_load, Research_interests) VALUES
-- Computer Science Lecturers
('Dr. Sarah Mitchell', 1, 'PhD Computer Science - MIT, MSc CS - Stanford', 'Artificial Intelligence, Machine Learning', 'CS401, CS501', 'Deep Learning, Natural Language Processing, Computer Vision'),
('Prof. James Chen', 1, 'PhD Computer Science - Berkeley, MSc CS - Carnegie Mellon', 'Database Systems, Software Engineering', 'CS301, CS201', 'Big Data, Cloud Computing, Database Optimization'),
('Dr. Emily Rodriguez', 1, 'PhD Computer Science - Oxford, BSc CS - Cambridge', 'Cybersecurity, Network Security', 'CS101', 'Cryptography, Network Security, Ethical Hacking'),

-- Mathematics Lecturers
('Prof. Michael Anderson', 2, 'PhD Mathematics - Princeton, MSc Math - MIT', 'Pure Mathematics, Abstract Algebra', 'MATH401, MATH301', 'Group Theory, Ring Theory, Number Theory'),
('Dr. Lisa Thompson', 2, 'PhD Applied Mathematics - Stanford, MSc Statistics - Berkeley', 'Applied Mathematics, Statistics', 'MATH201, MATH101', 'Statistical Modeling, Computational Mathematics'),

-- Physics Lecturers
('Prof. David Kumar', 3, 'PhD Physics - Caltech, MSc Physics - MIT', 'Quantum Mechanics, Particle Physics', 'PHYS501, PHYS301', 'Quantum Field Theory, High Energy Physics'),
('Dr. Rachel Green', 3, 'PhD Astrophysics - Cambridge, MSc Physics - Oxford', 'Astrophysics, Cosmology', 'PHYS201, PHYS101', 'Galaxy Formation, Dark Matter, Observational Astronomy'),

-- English Literature Lecturers
('Dr. William Shakespeare-Jones', 6, 'PhD English Literature - Yale, MA English - Harvard', 'Shakespeare Studies, Renaissance Literature', 'ENG201', 'Early Modern Drama, Shakespearean Criticism'),
('Prof. Margaret Atwood-Smith', 6, 'PhD English Literature - Cambridge, MA Creative Writing - Iowa', 'Modern Literature, Creative Writing', 'ENG301, ENG101', 'Contemporary Fiction, Postmodern Literature'),

-- Business Lecturers
('Dr. Robert Williams', 10, 'PhD Business Administration - Harvard, MBA - Wharton', 'Strategic Management, Finance', 'BUS401, BUS201', 'Corporate Strategy, Financial Markets'),
('Prof. Jennifer Martinez', 10, 'PhD Marketing - Northwestern, MBA - Stanford', 'Marketing, Consumer Behavior', 'BUS301, BUS101', 'Digital Marketing, Brand Management'),

-- Psychology Lecturers
('Dr. Amanda Foster', 9, 'PhD Clinical Psychology - UCLA, MSc Psychology - Columbia', 'Clinical Psychology, Therapy', 'PSY301', 'Cognitive Behavioral Therapy, Anxiety Disorders'),
('Prof. Daniel Brooks', 9, 'PhD Psychology - Stanford, MSc Neuroscience - Oxford', 'Cognitive Psychology, Neuroscience', 'PSY201, PSY101', 'Memory, Attention, Brain Imaging'),

-- Additional Lecturers for committees and research
('Dr. Patricia Lee', 1, 'PhD Computer Science - Cornell, MSc CS - UCLA', 'Software Engineering, Agile Methods', 'CS201', 'Software Testing, DevOps'),
('Prof. Thomas Wilson', 2, 'PhD Mathematics - Harvard, MSc Math - Princeton', 'Topology, Differential Geometry', 'MATH301', 'Algebraic Topology, Manifolds'),
('Dr. Susan Clark', 3, 'PhD Physics - Stanford, MSc Physics - Caltech', 'Condensed Matter Physics', 'PHYS201', 'Superconductivity, Quantum Materials');

-- Insert Non-academic Staff
INSERT INTO Non_academic_staff (Name, Job_Title, Department_ID, Employment_type, Contact_details, Salary, Emergency_contact_info) VALUES
('John Davis', 'IT Support Specialist', 1, 'Full-time', 'john.davis@university.edu, ext: 1234', 45000.00, 'Jane Davis: 555-0101'),
('Mary Johnson', 'Administrative Assistant', 1, 'Full-time', 'mary.johnson@university.edu, ext: 1235', 38000.00, 'Bob Johnson: 555-0102'),
('Peter Brown', 'Lab Technician', 3, 'Full-time', 'peter.brown@university.edu, ext: 2001', 42000.00, 'Lucy Brown: 555-0103'),
('Sandra White', 'Department Secretary', 2, 'Full-time', 'sandra.white@university.edu, ext: 1501', 36000.00, 'Tom White: 555-0104'),
('Michael Green', 'Laboratory Manager', 3, 'Full-time', 'michael.green@university.edu, ext: 2002', 52000.00, 'Sarah Green: 555-0105'),
('Linda Taylor', 'Finance Officer', 10, 'Full-time', 'linda.taylor@university.edu, ext: 3001', 48000.00, 'Mark Taylor: 555-0106'),
('Kevin Moore', 'Student Services Coordinator', NULL, 'Full-time', 'kevin.moore@university.edu, ext: 4001', 44000.00, 'Emma Moore: 555-0107'),
('Nancy Harris', 'Library Assistant', 6, 'Part-time', 'nancy.harris@university.edu, ext: 5001', 28000.00, 'Chris Harris: 555-0108'),
('George Martin', 'Facilities Manager', NULL, 'Full-time', 'george.martin@university.edu, ext: 6001', 55000.00, 'Helen Martin: 555-0109'),
('Carol Lewis', 'HR Coordinator', NULL, 'Full-time', 'carol.lewis@university.edu, ext: 7001', 50000.00, 'David Lewis: 555-0110');

-- ========================================
-- LEVEL 3: STUDENTS, RESEARCH PROJECTS
-- ========================================

-- Insert Students
INSERT INTO Students (Name, Date_of_birth, Contact_info, Program_id, Year_of_study, Current_Grades, Disciplinary_records, Graduation_status, Advisor_id) VALUES
-- Computer Science Students
('Alice Johnson', '2003-05-15', 'alice.j@student.edu, 555-1001', 1, 2, 'CS101: A, MATH101: A-, ENG101: B+', NULL, 'Active', 2),
('Bob Smith', '2002-08-22', 'bob.s@student.edu, 555-1002', 1, 3, 'CS201: B+, CS301: A-, MATH201: A', NULL, 'Active', 2),
('Charlie Brown', '2004-01-10', 'charlie.b@student.edu, 555-1003', 1, 1, 'CS101: B', NULL, 'Active', 3),
('Diana Prince', '2001-11-30', 'diana.p@student.edu, 555-1004', 5, 1, 'CS501: A, CS401: A-', NULL, 'Active', 1),
('Ethan Hunt', '2002-07-18', 'ethan.h@student.edu, 555-1005', 1, 4, 'CS401: A-, CS301: A, CS201: B+', NULL, 'Active', 1),

-- Mathematics Students
('Fiona Apple', '2003-03-25', 'fiona.a@student.edu, 555-1006', 2, 2, 'MATH201: A, MATH101: A-, CS101: B+', NULL, 'Active', 5),
('George Washington', '2003-09-12', 'george.w@student.edu, 555-1007', 2, 3, 'MATH301: B+, MATH201: A', NULL, 'Active', 4),
('Hannah Montana', '2004-02-14', 'hannah.m@student.edu, 555-1008', 2, 1, 'MATH101: A-', NULL, 'Active', 5),

-- Physics Students
('Isaac Newton', '2002-12-25', 'isaac.n@student.edu, 555-1009', 4, 3, 'PHYS301: A, PHYS201: A-, MATH201: A', NULL, 'Active', 6),
('Julia Roberts', '2003-06-08', 'julia.r@student.edu, 555-1010', 4, 2, 'PHYS201: B+, PHYS101: A-, MATH101: A', NULL, 'Active', 7),
('Kevin Spacey', '2001-04-20', 'kevin.s@student.edu, 555-1011', 9, 2, 'PHYS501: A-, PHYS301: A', NULL, 'Active', 6),

-- English Literature Students
('Laura Palmer', '2003-10-05', 'laura.p@student.edu, 555-1012', 3, 2, 'ENG201: A, ENG101: A-', NULL, 'Active', 8),
('Michael Scott', '2004-03-15', 'michael.s@student.edu, 555-1013', 3, 1, 'ENG101: B+', NULL, 'Active', 9),

-- Business Students
('Nancy Drew', '2002-09-28', 'nancy.d@student.edu, 555-1014', 6, 3, 'BUS301: A-, BUS201: A, BUS101: B+', NULL, 'Active', 10),
('Oliver Twist', '2003-07-19', 'oliver.t@student.edu, 555-1015', 6, 2, 'BUS201: B+, BUS101: A-', NULL, 'Active', 11),
('Patricia Hill', '2001-05-30', 'patricia.h@student.edu, 555-1016', 7, 1, 'BUS401: A-, BUS301: A', NULL, 'Active', 10),

-- Psychology Students
('Quincy Adams', '2003-11-11', 'quincy.a@student.edu, 555-1017', 8, 2, 'PSY201: A, PSY101: A-', NULL, 'Active', 12),
('Rachel Green', '2004-01-22', 'rachel.g@student.edu, 555-1018', 8, 1, 'PSY101: A-', NULL, 'Active', 13),
('Steven Universe', '2002-08-05', 'steven.u@student.edu, 555-1019', 8, 3, 'PSY301: A, PSY201: A-, PSY101: A', NULL, 'Active', 12),

-- History Students
('Tina Turner', '2003-12-01', 'tina.t@student.edu, 555-1020', 10, 2, 'History courses: A-', NULL, 'Active', NULL),

-- Additional students for variety
('Uma Thurman', '2002-06-15', 'uma.t@student.edu, 555-1021', 1, 4, 'CS401: B+, CS301: A-', 'Late submission warning - Fall 2024', 'Active', 2),
('Victor Hugo', '2003-04-08', 'victor.h@student.edu, 555-1022', 2, 3, 'MATH301: A, MATH201: A-', NULL, 'Active', 4),
('Wendy Williams', '2004-02-28', 'wendy.w@student.edu, 555-1023', 6, 1, 'BUS101: B+', NULL, 'Active', 11),
('Xavier Knight', '2001-10-10', 'xavier.k@student.edu, 555-1024', 5, 2, 'CS501: A-, CS401: A', NULL, 'Active', 1),
('Yolanda Yang', '2003-09-17', 'yolanda.y@student.edu, 555-1025', 8, 2, 'PSY201: A-, PSY101: A', NULL, 'Active', 13);

-- Insert Research Projects
INSERT INTO Research_Projects (Title, Principal_Investigator, Funding_sources, Outcomes) VALUES
('Deep Learning for Medical Image Analysis', 1, 'National Science Foundation ($500,000), Health Research Institute ($200,000)', 'Published 3 papers, Developed diagnostic tool prototype'),
('Quantum Computing Algorithms', 6, 'Department of Energy ($750,000)', '2 papers in review, Patent application filed'),
('Big Data Analytics in Cloud Environments', 2, 'Industry Partnership with TechCorp ($300,000)', 'Developed scalable framework, 1 paper published'),
('Cryptographic Protocols for IoT Devices', 3, 'Cybersecurity Institute ($400,000)', 'Ongoing - 1 paper published'),
('Machine Learning for Climate Prediction', 1, 'National Weather Service ($600,000), NSF ($400,000)', 'Improved prediction accuracy by 15%, 2 papers published'),
('Topology and Geometric Analysis', 14, 'American Mathematical Society Grant ($150,000)', '1 book chapter, 2 journal articles'),
('Condensed Matter Physics Studies', 15, 'National Science Foundation ($550,000)', 'Discovered new quantum material properties'),
('Shakespeare in Digital Age', 8, 'Humanities Council ($100,000)', 'Created digital archive, Published monograph'),
('Consumer Behavior in Digital Markets', 11, 'Marketing Research Foundation ($250,000)', 'Completed study of 10,000 consumers, 3 publications'),
('Cognitive Processes in Learning', 13, 'Education Research Institute ($350,000)', 'Developed new teaching methodology, 2 papers published');

-- ========================================
-- LEVEL 4: JUNCTION/ASSOCIATION TABLES
-- ========================================

-- Insert Course Enrollments
INSERT INTO Course_Enrollments (Student_id, Course_id, Enrollment_date, Semester, Academic_year, Status) VALUES
-- Alice Johnson (Student 1) - CS Year 2
(1, 2, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(1, 6, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(1, 10, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Bob Smith (Student 2) - CS Year 3
(2, 3, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(2, 4, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(2, 8, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Charlie Brown (Student 3) - CS Year 1
(3, 1, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(3, 6, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(3, 14, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Diana Prince (Student 4) - MS CS Year 1
(4, 5, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(4, 4, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Ethan Hunt (Student 5) - CS Year 4
(5, 4, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(5, 20, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Fiona Apple (Student 6) - Math Year 2
(6, 7, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(6, 1, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- George Washington (Student 7) - Math Year 3
(7, 8, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(7, 9, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Hannah Montana (Student 8) - Math Year 1
(8, 6, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Isaac Newton (Student 9) - Physics Year 3
(9, 12, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(9, 7, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Julia Roberts (Student 10) - Physics Year 2
(10, 11, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(10, 7, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Kevin Spacey (Student 11) - PhD Physics Year 2
(11, 13, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Laura Palmer (Student 12) - English Year 2
(12, 15, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(12, 16, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Michael Scott (Student 13) - English Year 1
(13, 14, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Nancy Drew (Student 14) - Business Year 3
(14, 19, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(14, 20, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Oliver Twist (Student 15) - Business Year 2
(15, 18, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(15, 17, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Patricia Hill (Student 16) - MBA Year 1
(16, 20, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(16, 19, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Quincy Adams (Student 17) - Psychology Year 2
(17, 22, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(17, 23, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Rachel Green (Student 18) - Psychology Year 1
(18, 21, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Steven Universe (Student 19) - Psychology Year 3
(19, 23, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(19, 22, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),

-- Additional enrollments
(21, 4, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(21, 3, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(22, 8, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(22, 9, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(23, 17, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(24, 5, '2024-09-01', 'Fall', '2024-2025', 'Enrolled'),
(25, 22, '2024-09-01', 'Fall', '2024-2025', 'Enrolled');

-- Insert Student Organizations
-- Note: Due to UNIQUE constraint on Name, each organization can only have one student record
-- This represents each student's membership in organizations
INSERT INTO Students_Organizations (Name, Description, Student_id, Join_date, Role) VALUES
('Computer Science Club - Alice Johnson', 'Student organization for CS majors and enthusiasts', 1, '2023-09-15', 'Member'),
('Computer Science Club - Bob Smith', 'Student organization for CS majors and enthusiasts', 2, '2022-09-10', 'President'),
('Computer Science Club - Charlie Brown', 'Student organization for CS majors and enthusiasts', 3, '2024-09-05', 'Member'),
('Computer Science Club - Ethan Hunt', 'Student organization for CS majors and enthusiasts', 5, '2021-09-15', 'Vice President'),
('AI Research Society - Diana Prince', 'Focus on artificial intelligence and machine learning', 4, '2024-09-01', 'Secretary'),
('AI Research Society - Ethan Hunt', 'Focus on artificial intelligence and machine learning', 5, '2023-02-10', 'Member'),
('Mathematics Society - Fiona Apple', 'Promotes interest in mathematics', 6, '2023-09-12', 'Treasurer'),
('Mathematics Society - George Washington', 'Promotes interest in mathematics', 7, '2022-09-08', 'Member'),
('Mathematics Society - Hannah Montana', 'Promotes interest in mathematics', 8, '2024-09-10', 'Member'),
('Physics Club - Isaac Newton', 'Student organization for physics enthusiasts', 9, '2022-09-15', 'President'),
('Physics Club - Julia Roberts', 'Student organization for physics enthusiasts', 10, '2023-09-12', 'Member'),
('Physics Club - Kevin Spacey', 'Student organization for physics enthusiasts', 11, '2023-09-01', 'Research Coordinator'),
('Literary Society - Laura Palmer', 'Discussion and appreciation of literature', 12, '2023-09-10', 'Events Coordinator'),
('Literary Society - Michael Scott', 'Discussion and appreciation of literature', 13, '2024-09-05', 'Member'),
('Business Leaders Club - Nancy Drew', 'Professional development for business students', 14, '2022-09-12', 'President'),
('Business Leaders Club - Oliver Twist', 'Professional development for business students', 15, '2023-09-15', 'Marketing Lead'),
('Business Leaders Club - Patricia Hill', 'Professional development for business students', 16, '2024-09-01', 'Member'),
('Entrepreneurship Society - Nancy Drew', 'Supports student entrepreneurs', 14, '2023-01-15', 'Member'),
('Entrepreneurship Society - Wendy Williams', 'Supports student entrepreneurs', 23, '2024-09-10', 'Member'),
('Psychology Research Group - Quincy Adams', 'Undergraduate research in psychology', 17, '2023-09-12', 'Research Assistant'),
('Psychology Research Group - Steven Universe', 'Undergraduate research in psychology', 19, '2022-09-10', 'Lead Researcher'),
('Student Government Association - Bob Smith', 'Represents student body interests', 2, '2023-01-10', 'Tech Committee Member'),
('Student Government Association - Isaac Newton', 'Represents student body interests', 9, '2023-09-01', 'Science Representative'),
('Debate Club - Laura Palmer', 'Competitive debate and public speaking', 12, '2023-09-15', 'Member'),
('Debate Club - Nancy Drew', 'Competitive debate and public speaking', 14, '2022-09-10', 'Captain'),
('Volunteer Corps - Alice Johnson', 'Community service and outreach', 1, '2023-09-20', 'Member'),
('Volunteer Corps - Rachel Green', 'Community service and outreach', 18, '2024-09-12', 'Member'),
('International Students Association - Diana Prince', 'Support for international students', 4, '2024-09-01', 'Member'),
('Women in STEM - Alice Johnson', 'Supports women in science and technology', 1, '2023-09-15', 'Member'),
('Women in STEM - Fiona Apple', 'Supports women in science and technology', 6, '2023-09-12', 'Outreach Coordinator');

-- Insert Course Instructors
INSERT INTO Course_Instructors (Course_ID, Lecturer_ID) VALUES
-- Computer Science courses
(1, 3),  -- CS101 - Dr. Emily Rodriguez
(2, 2),  -- CS201 - Prof. James Chen
(3, 2),  -- CS301 - Prof. James Chen
(4, 1),  -- CS401 - Dr. Sarah Mitchell
(5, 1),  -- CS501 - Dr. Sarah Mitchell

-- Mathematics courses
(6, 5),  -- MATH101 - Dr. Lisa Thompson
(7, 5),  -- MATH201 - Dr. Lisa Thompson
(8, 4),  -- MATH301 - Prof. Michael Anderson
(9, 4),  -- MATH401 - Prof. Michael Anderson

-- Physics courses
(10, 7), -- PHYS101 - Dr. Rachel Green
(11, 7), -- PHYS201 - Dr. Rachel Green
(12, 6), -- PHYS301 - Prof. David Kumar
(13, 6), -- PHYS501 - Prof. David Kumar

-- English Literature courses
(14, 9), -- ENG101 - Prof. Margaret Atwood-Smith
(15, 8), -- ENG201 - Dr. William Shakespeare-Jones
(16, 9), -- ENG301 - Prof. Margaret Atwood-Smith

-- Business courses
(17, 11), -- BUS101 - Prof. Jennifer Martinez
(18, 10), -- BUS201 - Dr. Robert Williams
(19, 11), -- BUS301 - Prof. Jennifer Martinez
(20, 10), -- BUS401 - Dr. Robert Williams

-- Psychology courses
(21, 13), -- PSY101 - Prof. Daniel Brooks
(22, 13), -- PSY201 - Prof. Daniel Brooks
(23, 12); -- PSY301 - Dr. Amanda Foster

-- Insert Committee Members
INSERT INTO Committee_Members (Committee_ID, Lecturer_ID, Role, Start_Date, End_Date) VALUES
-- Academic Standards Committee
(1, 4, 'Chair', '2020-01-15', NULL),
(1, 6, 'Member', '2021-09-01', NULL),
(1, 10, 'Member', '2022-01-10', NULL),

-- Research Ethics Committee
(2, 1, 'Chair', '2019-06-01', NULL),
(2, 12, 'Member', '2020-09-01', NULL),
(2, 6, 'Member', '2021-01-15', NULL),
(2, 13, 'Member', '2022-09-01', NULL),

-- Student Affairs Committee
(3, 9, 'Chair', '2021-09-01', NULL),
(3, 11, 'Member', '2022-01-10', NULL),
(3, 5, 'Member', '2020-09-15', NULL),

-- Faculty Development Committee
(4, 2, 'Chair', '2020-03-15', NULL),
(4, 7, 'Member', '2021-09-01', NULL),
(4, 8, 'Member', '2022-01-10', NULL),

-- Library Committee
(5, 8, 'Chair', '2019-01-20', NULL),
(5, 9, 'Member', '2020-09-01', NULL),
(5, 14, 'Member', '2021-09-01', NULL),

-- Admissions Committee
(6, 3, 'Member', '2020-08-01', NULL),
(6, 5, 'Member', '2021-01-15', NULL),
(6, 11, 'Chair', '2019-08-01', NULL),

-- Budget and Finance Committee
(7, 10, 'Chair', '2019-02-01', NULL),
(7, 2, 'Member', '2020-09-01', NULL),
(7, 4, 'Member', '2021-01-10', NULL),

-- Technology Infrastructure Committee
(8, 3, 'Chair', '2017-01-10', NULL),
(8, 1, 'Member', '2018-09-01', NULL),
(8, 13, 'Member', '2020-01-15', NULL);

-- Insert Research Team Members
INSERT INTO Research_Team_Members (Project_ID, Lecturer_ID) VALUES
-- Deep Learning for Medical Image Analysis (Project 1)
(1, 1),  -- Principal Investigator
(1, 3),  -- Team member

-- Quantum Computing Algorithms (Project 2)
(2, 6),  -- Principal Investigator
(2, 15), -- Team member

-- Big Data Analytics in Cloud Environments (Project 3)
(3, 2),  -- Principal Investigator
(3, 13), -- Team member

-- Cryptographic Protocols for IoT Devices (Project 4)
(4, 3),  -- Principal Investigator
(4, 1),  -- Team member

-- Machine Learning for Climate Prediction (Project 5)
(5, 1),  -- Principal Investigator
(5, 5),  -- Team member (statistician)
(5, 7),  -- Team member (physicist)

-- Topology and Geometric Analysis (Project 6)
(6, 14), -- Principal Investigator
(6, 4),  -- Team member

-- Condensed Matter Physics Studies (Project 7)
(7, 15), -- Principal Investigator
(7, 6),  -- Team member

-- Shakespeare in Digital Age (Project 8)
(8, 8),  -- Principal Investigator
(8, 9),  -- Team member

-- Consumer Behavior in Digital Markets (Project 9)
(9, 11), -- Principal Investigator
(9, 10), -- Team member

-- Cognitive Processes in Learning (Project 10)
(10, 13), -- Principal Investigator
(10, 12); -- Team member

-- Insert Publications
INSERT INTO Publications (Title, Publication_year, Publication_type, Lecturer_ID, Project_ID) VALUES
-- Project 1 - Deep Learning for Medical Image Analysis
('Convolutional Neural Networks for X-ray Image Classification', 2023, 'Journal Article', 1, 1),
('Deep Learning Approaches in Medical Diagnostics: A Survey', 2024, 'Journal Article', 1, 1),
('Automated Detection of Pulmonary Nodules Using 3D CNNs', 2024, 'Conference Paper', 3, 1),

-- Project 2 - Quantum Computing Algorithms
('Quantum Algorithm for Linear Systems of Equations', 2023, 'Journal Article', 6, 2),
('Optimizing Quantum Circuit Depth for NISQ Devices', 2024, 'Conference Paper', 6, 2),

-- Project 3 - Big Data Analytics
('Scalable Data Processing Framework for Cloud Environments', 2024, 'Journal Article', 2, 3),
('Performance Optimization in Distributed Database Systems', 2023, 'Conference Paper', 2, 3),

-- Project 4 - Cryptographic Protocols
('Lightweight Encryption for IoT Devices', 2024, 'Journal Article', 3, 4),
('Security Analysis of MQTT Protocol in IoT Networks', 2023, 'Conference Paper', 3, 4),

-- Project 5 - Machine Learning for Climate
('Machine Learning Models for Long-term Climate Prediction', 2023, 'Journal Article', 1, 5),
('Neural Networks for Weather Pattern Recognition', 2024, 'Journal Article', 1, 5),

-- Project 6 - Topology
('Geometric Structures on Manifolds', 2023, 'Book Chapter', 14, 6),
('Applications of Algebraic Topology in Data Analysis', 2024, 'Journal Article', 14, 6),
('Homological Methods in Topological Data Analysis', 2023, 'Journal Article', 4, 6),

-- Project 7 - Condensed Matter Physics
('Novel Superconducting Materials at Room Temperature', 2024, 'Journal Article', 15, 7),
('Quantum Properties of Two-Dimensional Materials', 2023, 'Journal Article', 15, 7),

-- Project 8 - Shakespeare Studies
('Digital Archives and Renaissance Literature', 2023, 'Monograph', 8, 8),
('Shakespeare in the Digital Humanities', 2024, 'Journal Article', 8, 8),
('Computational Analysis of Shakespearean Texts', 2024, 'Conference Paper', 9, 8),

-- Project 9 - Consumer Behavior
('Social Media Influence on Purchase Decisions', 2023, 'Journal Article', 11, 9),
('Digital Marketing Strategies in E-commerce', 2024, 'Journal Article', 11, 9),
('Consumer Trust in Online Marketplaces', 2023, 'Conference Paper', 10, 9),

-- Project 10 - Cognitive Processes
('Memory Enhancement Through Active Learning', 2023, 'Journal Article', 13, 10),
('Cognitive Load Theory in Online Education', 2024, 'Journal Article', 13, 10),
('Attention and Learning: A Neuroscience Perspective', 2024, 'Book Chapter', 12, 10),

-- Additional independent publications
('Software Engineering Best Practices', 2024, 'Journal Article', 2, NULL),
('Introduction to Abstract Algebra', 2023, 'Textbook', 4, NULL),
('Modern Physics for Undergraduates', 2023, 'Textbook', 7, NULL),
('Contemporary British Literature', 2024, 'Journal Article', 9, NULL),
('Strategic Management in Digital Age', 2023, 'Journal Article', 10, NULL),
('Clinical Psychology: Recent Advances', 2024, 'Book Chapter', 12, NULL);

-- ========================================
-- VERIFICATION AND SUMMARY
-- ========================================

SELECT '=== DATA POPULATION COMPLETE ===' AS 'STATUS';

-- Display summary statistics
SELECT '=== SUMMARY STATISTICS ===' AS 'INFO';

SELECT 'Departments' AS 'Table', COUNT(*) AS 'Records' FROM Departments
UNION ALL
SELECT 'Programs', COUNT(*) FROM Programs
UNION ALL
SELECT 'Committees', COUNT(*) FROM Committees
UNION ALL
SELECT 'Courses', COUNT(*) FROM Courses
UNION ALL
SELECT 'Lecturers', COUNT(*) FROM Lecturers
UNION ALL
SELECT 'Non_academic_staff', COUNT(*) FROM Non_academic_staff
UNION ALL
SELECT 'Students', COUNT(*) FROM Students
UNION ALL
SELECT 'Research_Projects', COUNT(*) FROM Research_Projects
UNION ALL
SELECT 'Course_Enrollments', COUNT(*) FROM Course_Enrollments
UNION ALL
SELECT 'Students_Organizations', COUNT(*) FROM Students_Organizations
UNION ALL
SELECT 'Course_Instructors', COUNT(*) FROM Course_Instructors
UNION ALL
SELECT 'Committee_Members', COUNT(*) FROM Committee_Members
UNION ALL
SELECT 'Research_Team_Members', COUNT(*) FROM Research_Team_Members
UNION ALL
SELECT 'Publications', COUNT(*) FROM Publications;

-- Sample queries to verify data integrity
SELECT '=== SAMPLE VERIFICATION QUERIES ===' AS 'INFO';

-- Show students with their programs and advisors
SELECT 
    s.Name AS Student,
    p.Name AS Program,
    l.Name AS Advisor
FROM Students s
LEFT JOIN Programs p ON s.Program_id = p.Program_ID
LEFT JOIN Lecturers l ON s.Advisor_id = l.Lecturer_ID
LIMIT 5;

-- Show courses with their instructors
SELECT 
    c.Course_Code,
    c.Name AS Course,
    l.Name AS Instructor
FROM Courses c
JOIN Course_Instructors ci ON c.Course_ID = ci.Course_ID
JOIN Lecturers l ON ci.Lecturer_ID = l.Lecturer_ID
LIMIT 5;

-- Show research projects with team sizes
SELECT 
    rp.Title,
    l.Name AS PI,
    COUNT(rtm.Lecturer_ID) AS Team_Size
FROM Research_Projects rp
JOIN Lecturers l ON rp.Principal_Investigator = l.Lecturer_ID
LEFT JOIN Research_Team_Members rtm ON rp.Project_ID = rtm.Project_ID
GROUP BY rp.Project_ID, rp.Title, l.Name
LIMIT 5;

SELECT '=== DUMMY DATA SUCCESSFULLY POPULATED ===' AS 'COMPLETION_STATUS';