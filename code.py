"""
Requirements:
- SQLAlchemy
- tkinter (built-in)
- pymysql
- Faker (for dummy data generation)

Install dependencies:
pip install sqlalchemy pymysql faker
"""

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext
from sqlalchemy import (
    create_engine, Column, Integer, String, Text, Date, DECIMAL,
    ForeignKey, TIMESTAMP, CheckConstraint, func, text
)
from sqlalchemy.orm import declarative_base, sessionmaker, relationship
from datetime import datetime, date, timedelta
import random
from faker import Faker

# DATABASE CONFIGURATION

DATABASE_CONFIG = {
    'user': 'root',
    'password': 'Abcd1234',
    'host': 'localhost',  # Change to your host
    'database': 'university_records'
}

# Create database connection string
DATABASE_URL = (
    f"mysql+pymysql://{DATABASE_CONFIG['user']}:"
    f"{DATABASE_CONFIG['password']}@{DATABASE_CONFIG['host']}/"
    f"{DATABASE_CONFIG['database']}?charset=utf8mb4"
)

# Create engine and session with encoding settings
engine = create_engine(
    DATABASE_URL,
    echo=False,
    pool_pre_ping=True,
    connect_args={
        'charset': 'utf8mb4',
        'use_unicode': True
    }
)
Session = sessionmaker(bind=engine)
Base = declarative_base()


# DATABASE MODELS (SQLAlchemy ORM)

class Department(Base):
    """Department model"""
    __tablename__ = 'Departments'

    Department_ID = Column(Integer, primary_key=True, autoincrement=True)
    Name = Column(String(100), nullable=False)
    Faculty = Column(String(100), nullable=False)
    Research_Areas = Column(Text)
    created_at = Column(TIMESTAMP, default=datetime.now)

    # Relationships
    courses = relationship('Course', back_populates='department')
    lecturers = relationship('Lecturer', back_populates='department')
    staff = relationship('NonAcademicStaff', back_populates='department')


class Program(Base):
    """Program model"""
    __tablename__ = 'Programs'

    Program_ID = Column(Integer, primary_key=True, autoincrement=True)
    Name = Column(String(150), nullable=False)
    Degree_awarded = Column(String(100), nullable=False)
    Program_Duration = Column(Text)
    Course_Requirements = Column(Text)
    Enrollment_details = Column(Text)
    created_at = Column(TIMESTAMP, default=datetime.now)

    # Relationships
    students = relationship('Student', back_populates='program')


class Committee(Base):
    """Committee model"""
    __tablename__ = 'Committees'

    Committee_ID = Column(Integer, primary_key=True, autoincrement=True)
    Name = Column(String(255), nullable=False)
    Description = Column(Text)
    Date_of_creation = Column(Date)

    # Relationships
    members = relationship('CommitteeMember', back_populates='committee')


class Course(Base):
    """Course model"""
    __tablename__ = 'Courses'

    Course_ID = Column(Integer, primary_key=True, autoincrement=True)
    Course_Code = Column(String(20), nullable=False, unique=True)
    Name = Column(String(150), nullable=False)
    Description = Column(Text)
    Department_ID = Column(Integer, ForeignKey('Departments.Department_ID'))
    Level = Column(String(20))
    Credits = Column(Integer, nullable=False)
    Prerequisites = Column(Text)
    Schedule = Column(String(100))
    Material = Column(Text)
    created_at = Column(TIMESTAMP, default=datetime.now)

    # Relationships
    department = relationship('Department', back_populates='courses')
    enrollments = relationship('CourseEnrollment', back_populates='course')
    instructors = relationship('CourseInstructor', back_populates='course')


class Lecturer(Base):
    """Lecturer model"""
    __tablename__ = 'Lecturers'

    Lecturer_ID = Column(Integer, primary_key=True, autoincrement=True)
    Name = Column(String(255), nullable=False)
    Department_ID = Column(Integer, ForeignKey('Departments.Department_ID'))
    Academic_Qualifications = Column(Text)
    Expertise = Column(Text)
    Course_load = Column(Text)
    Research_interests = Column(Text)

    # Relationships
    department = relationship('Department', back_populates='lecturers')
    advisees = relationship('Student', back_populates='advisor')
    course_assignments = relationship(
        'CourseInstructor', back_populates='lecturer'
    )
    research_projects = relationship(
        'ResearchProject', back_populates='principal_investigator'
    )
    committee_memberships = relationship(
        'CommitteeMember', back_populates='lecturer'
    )
    research_team = relationship(
        'ResearchTeamMember', back_populates='lecturer'
    )
    publications = relationship('Publication', back_populates='lecturer')


class NonAcademicStaff(Base):
    """Non-academic staff model"""
    __tablename__ = 'Non_academic_staff'

    Staff_ID = Column(Integer, primary_key=True, autoincrement=True)
    Name = Column(String(255), nullable=False)
    Job_Title = Column(String(100))
    Department_ID = Column(Integer, ForeignKey('Departments.Department_ID'))
    Employment_type = Column(String(100))
    Contact_details = Column(Text)
    Salary = Column(DECIMAL(12, 2))
    Emergency_contact_info = Column(String(255))

    # Relationships
    department = relationship('Department', back_populates='staff')


class Student(Base):
    """Student model"""
    __tablename__ = 'Students'

    Student_id = Column(Integer, primary_key=True, autoincrement=True)
    Name = Column(String(100), nullable=False)
    Date_of_birth = Column(Date, nullable=False)
    Contact_info = Column(String(150))
    Program_id = Column(Integer, ForeignKey('Programs.Program_ID'))
    Year_of_study = Column(Integer)
    Current_Grades = Column(Text)
    Disciplinary_records = Column(Text)
    Graduation_status = Column(String(20), default='Active')
    Advisor_id = Column(Integer, ForeignKey('Lecturers.Lecturer_ID'))
    created_at = Column(TIMESTAMP, default=datetime.now)

    # Relationships
    program = relationship('Program', back_populates='students')
    advisor = relationship('Lecturer', back_populates='advisees')
    enrollments = relationship('CourseEnrollment', back_populates='student')
    organizations = relationship(
        'StudentOrganization', back_populates='student'
    )


class ResearchProject(Base):
    """Research project model"""
    __tablename__ = 'Research_Projects'

    Project_ID = Column(Integer, primary_key=True, autoincrement=True)
    Title = Column(String(255), nullable=False)
    Principal_Investigator = Column(
        Integer, ForeignKey('Lecturers.Lecturer_ID')
    )
    Funding_sources = Column(Text)
    Outcomes = Column(Text)

    # Relationships
    principal_investigator = relationship(
        'Lecturer', back_populates='research_projects'
    )
    team_members = relationship(
        'ResearchTeamMember', back_populates='project'
    )
    publications = relationship('Publication', back_populates='project')


class CourseEnrollment(Base):
    """Course enrollment junction table"""
    __tablename__ = 'Course_Enrollments'

    Student_id = Column(
        Integer, ForeignKey('Students.Student_id'), primary_key=True
    )
    Course_id = Column(
        Integer, ForeignKey('Courses.Course_ID'), primary_key=True
    )
    Enrollment_date = Column(Date, default=date.today)
    Semester = Column(String(20))
    Academic_year = Column(String(10))
    Status = Column(String(20), default='Enrolled')

    # Relationships
    student = relationship('Student', back_populates='enrollments')
    course = relationship('Course', back_populates='enrollments')


class StudentOrganization(Base):
    """Student organization model"""
    __tablename__ = 'Students_Organizations'

    Organization_id = Column(Integer, primary_key=True, autoincrement=True)
    Name = Column(String(150), nullable=False, unique=True)
    Description = Column(String(255))
    Student_id = Column(Integer, ForeignKey('Students.Student_id'))
    Join_date = Column(Date, default=date.today)
    Role = Column(String(50))
    created_at = Column(TIMESTAMP, default=datetime.now)

    # Relationships
    student = relationship('Student', back_populates='organizations')


class CourseInstructor(Base):
    """Course instructor junction table"""
    __tablename__ = 'Course_Instructors'

    Course_Instructor_ID = Column(Integer, autoincrement=True, unique=True)
    Course_ID = Column(
        Integer, ForeignKey('Courses.Course_ID'), primary_key=True
    )
    Lecturer_ID = Column(
        Integer, ForeignKey('Lecturers.Lecturer_ID'), primary_key=True
    )

    # Relationships
    course = relationship('Course', back_populates='instructors')
    lecturer = relationship('Lecturer', back_populates='course_assignments')


class CommitteeMember(Base):
    """Committee member junction table"""
    __tablename__ = 'Committee_Members'

    Committee_Member_ID = Column(
        Integer, primary_key=True, autoincrement=True
    )
    Committee_ID = Column(Integer, ForeignKey('Committees.Committee_ID'))
    Lecturer_ID = Column(Integer, ForeignKey('Lecturers.Lecturer_ID'))
    Role = Column(String(100))
    Start_Date = Column(Date)
    End_Date = Column(Date)

    # Relationships
    committee = relationship('Committee', back_populates='members')
    lecturer = relationship('Lecturer', back_populates='committee_memberships')


class ResearchTeamMember(Base):
    """Research team member junction table"""
    __tablename__ = 'Research_Team_Members'

    Project_ID = Column(
        Integer, ForeignKey('Research_Projects.Project_ID'), primary_key=True
    )
    Lecturer_ID = Column(
        Integer, ForeignKey('Lecturers.Lecturer_ID'), primary_key=True
    )

    # Relationships
    project = relationship('ResearchProject', back_populates='team_members')
    lecturer = relationship('Lecturer', back_populates='research_team')


class Publication(Base):
    """Publication model"""
    __tablename__ = 'Publications'

    Publication_ID = Column(Integer, primary_key=True, autoincrement=True)
    Title = Column(String(255), nullable=False)
    Publication_year = Column(Integer)
    Publication_type = Column(String(100))
    Lecturer_ID = Column(Integer, ForeignKey('Lecturers.Lecturer_ID'))
    Project_ID = Column(Integer, ForeignKey('Research_Projects.Project_ID'))

    # Relationships
    lecturer = relationship('Lecturer', back_populates='publications')
    project = relationship('ResearchProject', back_populates='publications')


# DATA POPULATION FUNCTIONS

class DataPopulator:
    """Class to populate database with dummy data"""

    def __init__(self, session):
        self.session = session
        self.fake = Faker('en_US')  # Use English locale to avoid encoding issues

    def clear_all_data(self):
        """Clear all existing data from database"""
        try:
            self.session.query(Publication).delete()
            self.session.query(ResearchTeamMember).delete()
            self.session.query(CommitteeMember).delete()
            self.session.query(CourseInstructor).delete()
            self.session.query(StudentOrganization).delete()
            self.session.query(CourseEnrollment).delete()
            self.session.query(ResearchProject).delete()
            self.session.query(Student).delete()
            self.session.query(NonAcademicStaff).delete()
            self.session.query(Lecturer).delete()
            self.session.query(Course).delete()
            self.session.query(Committee).delete()
            self.session.query(Program).delete()
            self.session.query(Department).delete()
            self.session.commit()
            print("All data cleared successfully!")
        except Exception as e:
            self.session.rollback()
            print(f"Error clearing data: {e}")

    def populate_departments(self, count=10):
        """Populate departments"""
        departments = []
        dept_names = [
            'Computer Science', 'Mathematics', 'Physics', 'Chemistry',
            'Biology', 'Engineering', 'Business', 'Psychology',
            'History', 'Literature'
        ]
        faculties = [
            'Science', 'Engineering', 'Arts', 'Business'
        ]

        for i in range(min(count, len(dept_names))):
            dept = Department(
                Name=dept_names[i],
                Faculty=random.choice(faculties),
                Research_Areas=f"{dept_names[i]} Research, Applied {dept_names[i]}"
            )
            departments.append(dept)
            self.session.add(dept)

        self.session.commit()
        print(f"Added {len(departments)} departments")
        return departments

    def populate_programs(self, count=8):
        """Populate programs"""
        programs = []
        program_names = [
            ('Bachelor of Computer Science', 'BSc', '4 years'),
            ('Master of Computer Science', 'MSc', '2 years'),
            ('Bachelor of Engineering', 'BEng', '4 years'),
            ('Master of Business Administration', 'MBA', '2 years'),
            ('Bachelor of Science', 'BSc', '3 years'),
            ('Doctor of Philosophy', 'PhD', '4-6 years'),
            ('Bachelor of Arts', 'BA', '3 years'),
            ('Master of Science', 'MSc', '1-2 years')
        ]

        for name, degree, duration in program_names[:count]:
            program = Program(
                Name=name,
                Degree_awarded=degree,
                Program_Duration=duration,
                Course_Requirements='Complete all required courses',
                Enrollment_details='Open enrollment'
            )
            programs.append(program)
            self.session.add(program)

        self.session.commit()
        print(f"Added {len(programs)} programs")
        return programs

    def populate_committees(self, count=5):
        """Populate committees"""
        committees = []
        committee_names = [
            'Academic Standards Committee',
            'Research Ethics Committee',
            'Curriculum Development Committee',
            'Student Affairs Committee',
            'Faculty Hiring Committee'
        ]

        for i in range(min(count, len(committee_names))):
            committee = Committee(
                Name=committee_names[i],
                Description=f"Responsible for {committee_names[i].lower()}",
                Date_of_creation=self.fake.date_between(
                    start_date='-5y', end_date='today'
                )
            )
            committees.append(committee)
            self.session.add(committee)

        self.session.commit()
        print(f"Added {len(committees)} committees")
        return committees

    def populate_lecturers(self, departments, count=30):
        """Populate lecturers"""
        lecturers = []
        qualifications = [
            'PhD in Computer Science', 'PhD in Mathematics',
            'PhD in Physics', 'PhD in Engineering'
        ]
        expertise_areas = [
            'Machine Learning', 'Data Science', 'Artificial Intelligence',
            'Software Engineering', 'Database Systems', 'Networks',
            'Quantum Computing', 'Applied Mathematics'
        ]

        for i in range(count):
            lecturer = Lecturer(
                Name=self.fake.name(),
                Department_ID=random.choice(departments).Department_ID,
                Academic_Qualifications=random.choice(qualifications),
                Expertise=', '.join(random.sample(expertise_areas, 2)),
                Course_load='3-4 courses per semester',
                Research_interests=random.choice(expertise_areas)
            )
            lecturers.append(lecturer)
            self.session.add(lecturer)

        self.session.commit()
        print(f"Added {len(lecturers)} lecturers")
        return lecturers

    def populate_courses(self, departments, count=40):
        """Populate courses"""
        courses = []
        course_prefixes = ['CS', 'MATH', 'PHYS', 'CHEM', 'BIO', 'ENG']
        course_names = [
            'Introduction to Programming', 'Data Structures',
            'Algorithms', 'Database Systems', 'Operating Systems',
            'Computer Networks', 'Machine Learning', 'Web Development',
            'Software Engineering', 'Calculus I', 'Calculus II',
            'Linear Algebra', 'Discrete Mathematics'
        ]

        for i in range(count):
            prefix = random.choice(course_prefixes)
            course_num = random.randint(100, 499)
            course = Course(
                Course_Code=f"{prefix}{course_num}",
                Name=random.choice(course_names),
                Description=self.fake.text(max_nb_chars=200),
                Department_ID=random.choice(departments).Department_ID,
                Level=random.choice(['Undergraduate', 'Graduate']),
                Credits=random.choice([3, 4, 6]),
                Prerequisites='None' if i < 10 else f"{prefix}{course_num-100}",
                Schedule=f"{random.choice(['MWF', 'TTh'])} {random.randint(9, 16)}:00",
                Material='Textbook and online resources'
            )
            courses.append(course)
            self.session.add(course)

        self.session.commit()
        print(f"Added {len(courses)} courses")
        return courses

    def populate_students(self, programs, lecturers, count=100):
        """Populate students"""
        students = []

        for i in range(count):
            year = random.randint(1, 4)
            grades_list = [random.randint(60, 100) for _ in range(5)]

            student = Student(
                Name=self.fake.name(),
                Date_of_birth=self.fake.date_of_birth(
                    minimum_age=18, maximum_age=30
                ),
                Contact_info=self.fake.email(),
                Program_id=random.choice(programs).Program_ID,
                Year_of_study=year,
                Current_Grades=', '.join(map(str, grades_list)),
                Disciplinary_records='None',
                Graduation_status='Active' if year < 4 else random.choice(
                    ['Active', 'Graduated']
                ),
                Advisor_id=random.choice(lecturers).Lecturer_ID
            )
            students.append(student)
            self.session.add(student)

        self.session.commit()
        print(f"Added {len(students)} students")
        return students

    def populate_course_enrollments(self, students, courses, count=300):
        """Populate course enrollments"""
        enrollments = []
        semesters = ['Fall 2024', 'Spring 2025', 'Fall 2025']

        enrolled_pairs = set()
        attempts = 0
        max_attempts = count * 3

        while len(enrollments) < count and attempts < max_attempts:
            attempts += 1
            student = random.choice(students)
            course = random.choice(courses)

            pair = (student.Student_id, course.Course_ID)
            if pair in enrolled_pairs:
                continue

            enrolled_pairs.add(pair)
            enrollment = CourseEnrollment(
                Student_id=student.Student_id,
                Course_id=course.Course_ID,
                Enrollment_date=self.fake.date_between(
                    start_date='-1y', end_date='today'
                ),
                Semester=random.choice(semesters),
                Academic_year='2024-2025',
                Status='Enrolled'
            )
            enrollments.append(enrollment)
            self.session.add(enrollment)

        self.session.commit()
        print(f"Added {len(enrollments)} course enrollments")
        return enrollments

    def populate_course_instructors(self, courses, lecturers):
        """Populate course instructors"""
        assignments = []
        assigned_pairs = set()

        for course in courses:
            num_instructors = random.randint(1, 2)
            for _ in range(num_instructors):
                lecturer = random.choice(lecturers)
                pair = (course.Course_ID, lecturer.Lecturer_ID)

                if pair not in assigned_pairs:
                    assigned_pairs.add(pair)
                    assignment = CourseInstructor(
                        Course_ID=course.Course_ID,
                        Lecturer_ID=lecturer.Lecturer_ID
                    )
                    assignments.append(assignment)
                    self.session.add(assignment)

        self.session.commit()
        print(f"Added {len(assignments)} course instructor assignments")
        return assignments

    def populate_research_projects(self, lecturers, count=20):
        """Populate research projects"""
        projects = []

        for i in range(count):
            project = ResearchProject(
                Title=f"Research Project {i+1}: {self.fake.catch_phrase()}",
                Principal_Investigator=random.choice(lecturers).Lecturer_ID,
                Funding_sources=random.choice([
                    'NSF Grant', 'University Fund', 'Industry Partnership'
                ]),
                Outcomes='Ongoing research'
            )
            projects.append(project)
            self.session.add(project)

        self.session.commit()
        print(f"Added {len(projects)} research projects")
        return projects

    def populate_publications(self, lecturers, projects, count=50):
        """Populate publications"""
        publications = []
        pub_types = ['Journal', 'Conference', 'Book Chapter']

        for i in range(count):
            pub = Publication(
                Title=f"Publication {i+1}: {self.fake.catch_phrase()}",
                Publication_year=random.randint(2020, 2025),
                Publication_type=random.choice(pub_types),
                Lecturer_ID=random.choice(lecturers).Lecturer_ID,
                Project_ID=random.choice(projects).Project_ID if random.random() > 0.3 else None
            )
            publications.append(pub)
            self.session.add(pub)

        self.session.commit()
        print(f"Added {len(publications)} publications")
        return publications

    def populate_non_academic_staff(self, departments, count=20):
        """Populate non-academic staff"""
        staff_list = []
        job_titles = [
            'Administrative Assistant', 'IT Support', 'Lab Technician',
            'Librarian', 'Student Advisor', 'HR Manager'
        ]

        for i in range(count):
            staff = NonAcademicStaff(
                Name=self.fake.name(),
                Job_Title=random.choice(job_titles),
                Department_ID=random.choice(departments).Department_ID,
                Employment_type=random.choice(['Full-time', 'Part-time']),
                Contact_details=self.fake.email(),
                Salary=random.randint(30000, 80000),
                Emergency_contact_info=self.fake.phone_number()
            )
            staff_list.append(staff)
            self.session.add(staff)

        self.session.commit()
        print(f"Added {len(staff_list)} non-academic staff")
        return staff_list

    def populate_all(self):
        """Populate all tables with dummy data"""
        print("\n" + "="*60)
        print("POPULATING DATABASE WITH DUMMY DATA")
        print("="*60 + "\n")

        # Clear existing data
        # self.clear_all_data()

        # Populate in order of dependencies
        departments = self.populate_departments(10)
        programs = self.populate_programs(8)
        committees = self.populate_committees(5)
        lecturers = self.populate_lecturers(departments, 30)
        courses = self.populate_courses(departments, 40)
        students = self.populate_students(programs, lecturers, 100)
        self.populate_course_enrollments(students, courses, 300)
        self.populate_course_instructors(courses, lecturers)
        projects = self.populate_research_projects(lecturers, 20)
        self.populate_publications(lecturers, projects, 50)
        self.populate_non_academic_staff(departments, 20)

        print("\n" + "="*60)
        print("DATABASE POPULATION COMPLETED!")
        print("="*60 + "\n")


# QUERY FUNCTIONS

class DatabaseQueries:
    """Class containing all database query functions"""

    def __init__(self, session):
        self.session = session

    def query_1_students_in_course_by_lecturer(
        self, course_code, lecturer_name
    ):
        """
        Find all students enrolled in a specific course
        taught by a particular lecturer
        """
        results = self.session.query(
            Student.Name,
            Student.Contact_info,
            Course.Course_Code,
            Course.Name.label('Course_Name'),
            Lecturer.Name.label('Lecturer_Name')
        ).join(
            CourseEnrollment, Student.Student_id == CourseEnrollment.Student_id
        ).join(
            Course, CourseEnrollment.Course_id == Course.Course_ID
        ).join(
            CourseInstructor, Course.Course_ID == CourseInstructor.Course_ID
        ).join(
            Lecturer, CourseInstructor.Lecturer_ID == Lecturer.Lecturer_ID
        ).filter(
            Course.Course_Code == course_code,
            Lecturer.Name.like(f'%{lecturer_name}%')
        ).all()

        return results

    def query_2_high_performing_final_year_students(self):
        """
        List all students with average grade above 70%
        who are in their final year
        """
        students = self.session.query(Student).filter(
            Student.Year_of_study == 4
        ).all()

        results = []
        for student in students:
            if student.Current_Grades:
                grades = [
                    float(g.strip())
                    for g in student.Current_Grades.split(',')
                    if g.strip().replace('.', '').isdigit()
                ]
                if grades and sum(grades) / len(grades) > 70:
                    results.append({
                        'Name': student.Name,
                        'Program': student.program.Name if student.program else 'N/A',
                        'Average_Grade': round(sum(grades) / len(grades), 2),
                        'Year': student.Year_of_study,
                        'Contact': student.Contact_info
                    })

        return results

    def query_3_students_not_enrolled(self, semester='Fall 2025'):
        """
        Identify students who haven't registered for
        any courses in the current semester
        """
        enrolled_students = self.session.query(
            CourseEnrollment.Student_id
        ).filter(
            CourseEnrollment.Semester == semester
        ).distinct().subquery()

        results = self.session.query(
            Student.Name,
            Student.Contact_info,
            Student.Year_of_study,
            Program.Name.label('Program_Name')
        ).outerjoin(
            enrolled_students,
            Student.Student_id == enrolled_students.c.Student_id
        ).join(
            Program, Student.Program_id == Program.Program_ID
        ).filter(
            enrolled_students.c.Student_id.is_(None)
        ).all()

        return results

    def query_4_advisor_contact(self, student_name):
        """Retrieve contact information for faculty advisor of a student"""
        results = self.session.query(
            Student.Name.label('Student_Name'),
            Lecturer.Name.label('Advisor_Name'),
            Lecturer.Expertise,
            Department.Name.label('Department')
        ).join(
            Lecturer, Student.Advisor_id == Lecturer.Lecturer_ID
        ).join(
            Department, Lecturer.Department_ID == Department.Department_ID
        ).filter(
            Student.Name.like(f'%{student_name}%')
        ).all()

        return results

    def query_5_lecturers_by_expertise(self, expertise_area):
        """Search for lecturers with expertise in a particular research area"""
        results = self.session.query(
            Lecturer.Name,
            Lecturer.Expertise,
            Lecturer.Research_interests,
            Department.Name.label('Department')
        ).join(
            Department, Lecturer.Department_ID == Department.Department_ID
        ).filter(
            (Lecturer.Expertise.like(f'%{expertise_area}%')) |
            (Lecturer.Research_interests.like(f'%{expertise_area}%'))
        ).all()

        return results

    def query_6_courses_by_department(self, department_name):
        """List all courses taught by lecturers in a specific department"""
        results = self.session.query(
            Course.Course_Code,
            Course.Name.label('Course_Name'),
            Course.Credits,
            Lecturer.Name.label('Lecturer_Name'),
            Department.Name.label('Department')
        ).join(
            CourseInstructor, Course.Course_ID == CourseInstructor.Course_ID
        ).join(
            Lecturer, CourseInstructor.Lecturer_ID == Lecturer.Lecturer_ID
        ).join(
            Department, Lecturer.Department_ID == Department.Department_ID
        ).filter(
            Department.Name.like(f'%{department_name}%')
        ).all()

        return results

    def query_7_top_research_supervisors(self, limit=10):
        """
        Identify lecturers who have supervised
        the most student research projects
        """
        results = self.session.query(
            Lecturer.Name,
            Department.Name.label('Department'),
            func.count(ResearchProject.Project_ID).label('Project_Count')
        ).join(
            ResearchProject,
            Lecturer.Lecturer_ID == ResearchProject.Principal_Investigator
        ).join(
            Department, Lecturer.Department_ID == Department.Department_ID
        ).group_by(
            Lecturer.Lecturer_ID, Lecturer.Name, Department.Name
        ).order_by(
            func.count(ResearchProject.Project_ID).desc()
        ).limit(limit).all()

        return results

    def query_8_publications_last_year(self, year=2024):
        """Generate report on publications of lecturers in the past year"""
        results = self.session.query(
            Lecturer.Name.label('Lecturer_Name'),
            Department.Name.label('Department'),
            Publication.Title,
            Publication.Publication_year,
            Publication.Publication_type
        ).join(
            Publication, Lecturer.Lecturer_ID == Publication.Lecturer_ID
        ).join(
            Department, Lecturer.Department_ID == Department.Department_ID
        ).filter(
            Publication.Publication_year >= year
        ).order_by(
            Publication.Publication_year.desc(),
            Lecturer.Name
        ).all()

        return results

    def query_9_students_by_advisor(self, lecturer_name):
        """Retrieve names of students advised by a specific lecturer"""
        results = self.session.query(
            Student.Name.label('Student_Name'),
            Student.Year_of_study,
            Program.Name.label('Program'),
            Student.Contact_info
        ).join(
            Lecturer, Student.Advisor_id == Lecturer.Lecturer_ID
        ).join(
            Program, Student.Program_id == Program.Program_ID
        ).filter(
            Lecturer.Name.like(f'%{lecturer_name}%')
        ).all()

        return results

    def query_10_staff_by_department(self, department_name):
        """Find all staff members employed in a specific department"""
        results = self.session.query(
            NonAcademicStaff.Name,
            NonAcademicStaff.Job_Title,
            NonAcademicStaff.Employment_type,
            NonAcademicStaff.Contact_details,
            Department.Name.label('Department')
        ).join(
            Department,
            NonAcademicStaff.Department_ID == Department.Department_ID
        ).filter(
            Department.Name.like(f'%{department_name}%')
        ).all()

        return results


# GUI APPLICATION

class UniversityDatabaseGUI:
    """Main GUI application for university database queries"""

    def __init__(self, root):
        self.root = root
        self.root.title("University Records Management System")
        self.root.geometry("1200x700")

        # Initialize database session
        self.session = Session()
        self.queries = DatabaseQueries(self.session)

        # Setup GUI
        self.setup_ui()

    def setup_ui(self):
        """Setup the user interface"""
        # Title
        title_frame = tk.Frame(self.root, bg='#2c3e50', height=80)
        title_frame.pack(fill=tk.X)
        title_frame.pack_propagate(False)

        title_label = tk.Label(
            title_frame,
            text="University Records Management System",
            font=('Arial', 20, 'bold'),
            bg='#2c3e50',
            fg='white'
        )
        title_label.pack(pady=20)

        # Main container
        main_container = tk.Frame(self.root)
        main_container.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)

        # Left panel - Query selection
        left_panel = tk.Frame(main_container, width=350, bg='#ecf0f1')
        left_panel.pack(side=tk.LEFT, fill=tk.BOTH, padx=(0, 10))
        left_panel.pack_propagate(False)

        # Query selection label
        tk.Label(
            left_panel,
            text="Select Query",
            font=('Arial', 14, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        # Query buttons
        queries_info = [
            ("1. Students in Course by Lecturer",
             self.show_query_1_form),
            ("2. High-Performing Final Year Students",
             self.execute_query_2),
            ("3. Students Not Enrolled This Semester",
             self.show_query_3_form),
            ("4. Advisor Contact Information",
             self.show_query_4_form),
            ("5. Lecturers by Expertise",
             self.show_query_5_form),
            ("6. Courses by Department",
             self.show_query_6_form),
            ("7. Top Research Supervisors",
             self.execute_query_7),
            ("8. Publications Report (Last Year)",
             self.show_query_8_form),
            ("9. Students by Advisor",
             self.show_query_9_form),
            ("10. Staff by Department",
             self.show_query_10_form)
        ]

        for query_text, command in queries_info:
            btn = tk.Button(
                left_panel,
                text=query_text,
                command=command,
                width=40,
                height=2,
                font=('Arial', 10),
                bg='#3498db',
                fg='white',
                cursor='hand2',
                relief=tk.RAISED
            )
            btn.pack(pady=5, padx=10)

        # Right panel - Results display
        right_panel = tk.Frame(main_container)
        right_panel.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True)

        # Input frame (for query parameters)
        self.input_frame = tk.Frame(right_panel, bg='#ecf0f1')
        self.input_frame.pack(fill=tk.X, pady=(0, 10))

        # Results frame
        results_label = tk.Label(
            right_panel,
            text="Query Results",
            font=('Arial', 14, 'bold')
        )
        results_label.pack(pady=5)

        # Results text area with scrollbar
        results_container = tk.Frame(right_panel)
        results_container.pack(fill=tk.BOTH, expand=True)

        scrollbar = tk.Scrollbar(results_container)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)

        self.results_text = scrolledtext.ScrolledText(
            results_container,
            font=('Courier', 10),
            wrap=tk.WORD,
            yscrollcommand=scrollbar.set
        )
        self.results_text.pack(fill=tk.BOTH, expand=True)
        scrollbar.config(command=self.results_text.yview)

        # Bottom button frame
        bottom_frame = tk.Frame(self.root)
        bottom_frame.pack(fill=tk.X, padx=10, pady=10)

        clear_btn = tk.Button(
            bottom_frame,
            text="Clear Results",
            command=self.clear_results,
            font=('Arial', 11),
            bg='#e74c3c',
            fg='white',
            width=15
        )
        clear_btn.pack(side=tk.LEFT, padx=5)

        populate_btn = tk.Button(
            bottom_frame,
            text="Populate Database",
            command=self.populate_database,
            font=('Arial', 11),
            bg='#27ae60',
            fg='white',
            width=15
        )
        populate_btn.pack(side=tk.LEFT, padx=5)

    def clear_input_frame(self):
        """Clear all widgets from input frame"""
        for widget in self.input_frame.winfo_children():
            widget.destroy()

    def clear_results(self):
        """Clear results text area"""
        self.results_text.delete(1.0, tk.END)

    def display_results(self, results, headers=None):
        """Display query results in formatted way"""
        self.clear_results()

        if not results:
            self.results_text.insert(tk.END, "No results found.\n")
            return

        # Display count
        self.results_text.insert(
            tk.END,
            f"Found {len(results)} result(s)\n"
        )
        self.results_text.insert(tk.END, "=" * 80 + "\n\n")

        # Display results
        for i, result in enumerate(results, 1):
            self.results_text.insert(tk.END, f"Result #{i}:\n")

            if isinstance(result, dict):
                for key, value in result.items():
                    self.results_text.insert(tk.END, f"  {key}: {value}\n")
            else:
                # Handle SQLAlchemy result tuples
                if hasattr(result, '_asdict'):
                    result_dict = result._asdict()
                    for key, value in result_dict.items():
                        self.results_text.insert(tk.END, f"  {key}: {value}\n")
                else:
                    self.results_text.insert(tk.END, f"  {result}\n")

            self.results_text.insert(tk.END, "\n" + "-" * 80 + "\n\n")

    # Query 1: Students in course by lecturer
    def show_query_1_form(self):
        """Show input form for query 1"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="Find Students in Course by Lecturer",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        # Course code input
        tk.Label(
            self.input_frame,
            text="Course Code:",
            bg='#ecf0f1'
        ).pack()
        course_entry = tk.Entry(self.input_frame, width=30)
        course_entry.pack(pady=5)

        # Lecturer name input
        tk.Label(
            self.input_frame,
            text="Lecturer Name:",
            bg='#ecf0f1'
        ).pack()
        lecturer_entry = tk.Entry(self.input_frame, width=30)
        lecturer_entry.pack(pady=5)

        # Execute button
        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_1(
                course_entry.get(),
                lecturer_entry.get()
            ),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_1(self, course_code, lecturer_name):
        """Execute query 1"""
        if not course_code or not lecturer_name:
            messagebox.showwarning(
                "Input Required",
                "Please enter both course code and lecturer name"
            )
            return

        results = self.queries.query_1_students_in_course_by_lecturer(
            course_code, lecturer_name
        )
        self.display_results(results)

    # Query 2: High performing students
    def execute_query_2(self):
        """Execute query 2 - no input needed"""
        self.clear_input_frame()
        results = self.queries.query_2_high_performing_final_year_students()
        self.display_results(results)

    # Query 3: Students not enrolled
    def show_query_3_form(self):
        """Show input form for query 3"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="Students Not Enrolled in Semester",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        tk.Label(
            self.input_frame,
            text="Semester:",
            bg='#ecf0f1'
        ).pack()
        semester_entry = tk.Entry(self.input_frame, width=30)
        semester_entry.insert(0, "Fall 2025")
        semester_entry.pack(pady=5)

        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_3(semester_entry.get()),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_3(self, semester):
        """Execute query 3"""
        results = self.queries.query_3_students_not_enrolled(semester)
        self.display_results(results)

    # Query 4: Advisor contact
    def show_query_4_form(self):
        """Show input form for query 4"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="Get Advisor Contact Information",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        tk.Label(
            self.input_frame,
            text="Student Name:",
            bg='#ecf0f1'
        ).pack()
        student_entry = tk.Entry(self.input_frame, width=30)
        student_entry.pack(pady=5)

        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_4(student_entry.get()),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_4(self, student_name):
        """Execute query 4"""
        if not student_name:
            messagebox.showwarning(
                "Input Required",
                "Please enter a student name"
            )
            return

        results = self.queries.query_4_advisor_contact(student_name)
        self.display_results(results)

    # Query 5: Lecturers by expertise
    def show_query_5_form(self):
        """Show input form for query 5"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="Search Lecturers by Expertise",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        tk.Label(
            self.input_frame,
            text="Expertise Area:",
            bg='#ecf0f1'
        ).pack()
        expertise_entry = tk.Entry(self.input_frame, width=30)
        expertise_entry.pack(pady=5)

        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_5(expertise_entry.get()),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_5(self, expertise):
        """Execute query 5"""
        if not expertise:
            messagebox.showwarning(
                "Input Required",
                "Please enter an expertise area"
            )
            return

        results = self.queries.query_5_lecturers_by_expertise(expertise)
        self.display_results(results)

    # Query 6: Courses by department
    def show_query_6_form(self):
        """Show input form for query 6"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="List Courses by Department",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        tk.Label(
            self.input_frame,
            text="Department Name:",
            bg='#ecf0f1'
        ).pack()
        dept_entry = tk.Entry(self.input_frame, width=30)
        dept_entry.pack(pady=5)

        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_6(dept_entry.get()),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_6(self, department):
        """Execute query 6"""
        if not department:
            messagebox.showwarning(
                "Input Required",
                "Please enter a department name"
            )
            return

        results = self.queries.query_6_courses_by_department(department)
        self.display_results(results)

    # Query 7: Top research supervisors
    def execute_query_7(self):
        """Execute query 7 - no input needed"""
        self.clear_input_frame()
        results = self.queries.query_7_top_research_supervisors(10)
        self.display_results(results)

    # Query 8: Publications report
    def show_query_8_form(self):
        """Show input form for query 8"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="Publications Report",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        tk.Label(
            self.input_frame,
            text="Year:",
            bg='#ecf0f1'
        ).pack()
        year_entry = tk.Entry(self.input_frame, width=30)
        year_entry.insert(0, "2024")
        year_entry.pack(pady=5)

        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_8(int(year_entry.get())),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_8(self, year):
        """Execute query 8"""
        results = self.queries.query_8_publications_last_year(year)
        self.display_results(results)

    # Query 9: Students by advisor
    def show_query_9_form(self):
        """Show input form for query 9"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="Get Students by Advisor",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        tk.Label(
            self.input_frame,
            text="Lecturer Name:",
            bg='#ecf0f1'
        ).pack()
        lecturer_entry = tk.Entry(self.input_frame, width=30)
        lecturer_entry.pack(pady=5)

        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_9(lecturer_entry.get()),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_9(self, lecturer_name):
        """Execute query 9"""
        if not lecturer_name:
            messagebox.showwarning(
                "Input Required",
                "Please enter a lecturer name"
            )
            return

        results = self.queries.query_9_students_by_advisor(lecturer_name)
        self.display_results(results)

    # Query 10: Staff by department
    def show_query_10_form(self):
        """Show input form for query 10"""
        self.clear_input_frame()

        tk.Label(
            self.input_frame,
            text="Find Staff by Department",
            font=('Arial', 12, 'bold'),
            bg='#ecf0f1'
        ).pack(pady=10)

        tk.Label(
            self.input_frame,
            text="Department Name:",
            bg='#ecf0f1'
        ).pack()
        dept_entry = tk.Entry(self.input_frame, width=30)
        dept_entry.pack(pady=5)

        tk.Button(
            self.input_frame,
            text="Execute Query",
            command=lambda: self.execute_query_10(dept_entry.get()),
            bg='#3498db',
            fg='white'
        ).pack(pady=10)

    def execute_query_10(self, department):
        """Execute query 10"""
        if not department:
            messagebox.showwarning(
                "Input Required",
                "Please enter a department name"
            )
            return

        results = self.queries.query_10_staff_by_department(department)
        self.display_results(results)

    def populate_database(self):
        """Populate database with dummy data"""
        response = messagebox.askyesno(
            "Populate Database",
            "This will add dummy data to the database. Continue?"
        )
        if response:
            try:
                populator = DataPopulator(self.session)
                populator.populate_all()
                messagebox.showinfo(
                    "Success",
                    "Database populated successfully!"
                )
            except Exception as e:
                messagebox.showerror(
                    "Error",
                    f"Error populating database: {str(e)}"
                )

    def __del__(self):
        """Cleanup on exit"""
        if hasattr(self, 'session'):
            self.session.close()


# MAIN EXECUTION

def main():
    """Main function to run the application"""
    try:
        # Test database connection
        print("Testing database connection...")
        session = Session()
        session.execute(text("SELECT 1"))
        session.close()
        print("Database connection successful!\n")

        # Create and run GUI
        root = tk.Tk()
        app = UniversityDatabaseGUI(root)
        root.mainloop()

    except Exception as e:
        print(f"Error: {e}")
        messagebox.showerror(
            "Database Connection Error",
            f"Could not connect to database:\n{str(e)}\n\n"
            "Please check your database configuration."
        )


if __name__ == "__main__":
    main()