# Database Management System
# 🏫 University Record Management System (URMS)
---

## 📘 Project Overview

The **University Record Management System (URMS)** is a relational database-driven application designed to streamline the management of academic and administrative data within a higher education setting. The system integrates a **MySQL backend** with a **Python Tkinter GUI frontend**, enabling efficient querying, record retrieval, and report generation for students, lecturers, staff, courses, and research projects.

---

## 🎯 Objectives

* Develop a **normalized relational schema** for academic record management.  
* Implement **secure, query-driven data retrieval** using MySQL and Python.  
* Design an **accessible and user-friendly GUI** for real-time interaction.  
* Demonstrate **data integrity, usability, and system reliability** through testing and documentation.

---

## 🧩 System Architecture

* **Backend:** MySQL 8.0 — Schema design, data normalization (1NF/2NF), SQL queries.  
* **Frontend:** Python (Tkinter) — Interactive GUI with parameterized SQL execution.  
* **Connector:** `mysql.connector` / `PyMySQL` for database communication.  
* **Version Control:** GitHub (shared repository for collaboration).  
* **Development Tools:** MySQL Workbench, Visual Studio, PyCharm, Microsoft Teams.

---

## ⚙️ Core Features

* **Student Management:** Enrollment tracking, course registration, and academic performance.  
* **Lecturer Management:** Departmental allocation, research supervision, and committee membership.  
* **Departmental Operations:** Course offerings, staff employment, and research project oversight.  
* **Query Engine:** Executes 6+ core parameterized queries (e.g., enrolled students, top researchers).  
* **Accessibility & Security:** Follows usability heuristics and uses parameterized SQL to prevent injection attacks.

---

## 🧠 Project Management

* Adopted a **hybrid Agile–Waterfall** development model.  
* Project duration: **24 September – 4 October 2025.**  
* Teams coordinated via GitHub and Microsoft Teams.  
* Major Milestones:
  * **Phase 1:** ERD design & database setup  
  * **Phase 2:** Data population & query testing  
  * **Phase 3:** Python–MySQL integration  
  * **Phase 4:** GUI development & documentation  
  * **Phase 5:** Final submission & demo recording

---

## 🧮 ERD and Schema Design

* Core entities: Students, Lecturers, Courses, Departments, Programs, Research Projects, Publications, Committees, Non-Academic Staff.  
* Many-to-many relationships resolved via **junction tables** (e.g., Enrollments, Course_Instructors, Research_Team_Members).  
* Referential integrity maintained with **foreign keys**, **constraints**, and **indexes**.

---

## 🚧 Implementation Challenges & Resolutions

### 1. Cross-platform Frontend/DB Compatibility
* **Issue:** Dependency mismatch across macOS and Windows builds.  
* **Fix:** Version pinning, standardized on PyMySQL, and CI smoke testing.

### 2. Remote Database Access
* **Issue:** MySQL Error 1141 (user@host mismatch).  
* **Fix:** Reconfigured user grants, opened port 3306, and standardized authentication plugins.

---

## ✅ Deliverables

* **Normalized database schema and ERD**  
* **Python Tkinter frontend with live query execution**  
* **Functional test logs and validation screenshots**  
* **Comprehensive project report (this document)**  
* **Demo video and GitHub repository**

---

## 👥 Project Team

| Name                         | Role                               | Team   |
| ----------------------------- | ---------------------------------- | ------ |
| **Nduta, Tabitha Elsie**     | Backend Database Engineer          | Team A |
| **Issa, Shafi Suleiman**     | Backend Database Engineer          | Team A |
| **Chan, Man Man**            | Frontend Software Engineer         | Team B |
| **Kerai, Nikul**             | Frontend Software Engineer, Tester | Team B |
| **Adepoju, Samuel Temitayo** | Project Manager, Tester            | Team C |

---

## 🏁 Conclusion

The URMS project successfully delivered a functional, normalized, and accessible record management system. It demonstrates technical rigor, usability, and reproducibility through version control, clear documentation, and environment consistency. The final product aligns with academic data governance standards and sets a foundation for future extensions such as authentication systems and web-based interfaces.
