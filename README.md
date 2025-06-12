# University Management System Database

This repository contains a comprehensive PostgreSQL database schema designed for a full-featured University Management System. It supports academic operations, infrastructure tracking, library management, attendance monitoring, fee payments, and user authentication.

---

## Table of Contents

- [Overview](#overview)
- [Database Design](#database-design)
  - [Core Modules](#core-modules)
  - [Extended Features](#extended-features)
- [Schema Details](#schema-details)
  - [Departments](#departments)
  - [Faculties](#faculties)
  - [Students](#students)
  - [Subjects](#subjects)
  - [Faculty-Subject Assignments](#faculty-subject-assignments)
  - [Student Enrollments](#student-enrollments)
  - [Classrooms](#classrooms)
  - [Library Books](#library-books)
  - [Library Book Issues](#library-book-issues)
  - [Canteen](#canteen)
  - [Grades / Marks](#grades--marks)
  - [Attendance](#attendance)
  - [Payments / Fees](#payments--fees)
  - [User Login System](#user-login-system)
- [Installation & Setup](#installation--setup)
- [Future Extensions](#future-extensions)
- [License](#license)

---

## Overview

The University Management System schema is built to manage the following:
- **Academic Operations:** Departments, Faculties, Students, Subjects, Faculty assignments, and Student enrollments.
- **Infrastructure:** Classrooms, Library resources, and Canteen items.
- **Extended Academic Services:** Grade tracking, attendance records, and fee/payment transactions.
- **User Portal:** A user authentication system for students, faculties, and administrators.

This design ensures data integrity, normalized relationships, and performance optimizations through indices and constraints. 

---

## Database Design

### Core Modules

1. **Departments:** Central administrative units. All faculties, students, and subjects are linked to a department.
2. **Faculties:** Staff with roles (faculty, Head of Department (HOD), or admin) managing and teaching subjects.
3. **Students:** Learners enrolled in different departments, managed by unique enrollment year.
4. **Subjects:** Academic courses that belong to departments.
5. **Assignments & Enrollments:** 
   - **Faculty-Subject Assignments** link faculties to subjects they teach.
   - **Student Enrollments** record the subjects in which students are registered.

### Extended Features

1. **Infrastructure Tables:** 
   - **Classrooms** track room data and capacities.
   - **Library Books** and **Library Book Issues** manage book inventories and lending records.
   - **Canteen** holds menu items with pricing.
2. **Academic Assessments:**
   - **Grades/Marks** track student performance for exams.
   - **Attendance** monitors student participation in classes.
3. **Financial Transactions:**
   - **Payments/Fees** capture fee records for various services.
4. **User Authentication:**
   - **Users** table supports login functionality for the academic portal.

---

## Schema Details

### Departments
- **Table:** `departments`
- **Description:** Stores department names and building locations.
- **Key Features:**
  - Unique department names.
  - Primary key auto-generated.

### Faculties
- **Table:** `faculties`
- **Description:** Contains faculty member details including their name, associated department, position title, and role type.
- **Key Features:**
  - Role type constrained to 'faculty', 'HOD', or 'admin'.
  - Index on `department_id` for performance.
  
### Students
- **Table:** `students`
- **Description:** Contains student details, including enrollment year and linked department.
- **Key Features:**
  - Enrollment year must be later than or equal to 1900.
  - Index on `department_id`.

### Subjects
- **Table:** `subjects`
- **Description:** Represents academic subjects taught within departments.
- **Key Features:**
  - Credits must be a positive value.
  - Unique subject name for each department.
  - Index on `department_id`.

### Faculty-Subject Assignments
- **Table:** `faculty_subjects`
- **Description:** A junction table connecting faculties with subjects they teach.
- **Key Features:**
  - Unique constraint on faculty and subject pairs.
  - Indices on both `faculty_id` and `subject_id`.

### Student Enrollments
- **Table:** `enrollments`
- **Description:** Tracks subject enrollments by students.
- **Key Features:**
  - Unique enrollment per student for a subject.
  - Cascading deletes to maintain referential integrity.
  - Indices on `student_id` and `subject_id`.

### Classrooms
- **Table:** `classrooms`
- **Description:** Contains classroom identifiers, including room number, building, and capacity.
- **Key Features:**
  - Unique constraint across room number and building.
  - Capacity checked for values greater than zero.

### Library Books
- **Table:** `library_books`
- **Description:** Stores details of books available in the library.
- **Key Features:**
  - Unique ISBN constraint.

### Library Book Issues
- **Table:** `library_issues`
- **Description:** Logs book issuance records to students.
- **Key Features:**
  - Cascade deletion when a student or book record is removed.
  - Indices on `student_id` and `book_id`.

### Canteen
- **Table:** `canteen`
- **Description:** Manages canteen menu items and pricing.
- **Key Features:**
  - Price validation to ensure non-negative amounts.

### Grades / Marks
- **Table:** `grades`
- **Description:** Tracks grades or marks awarded to students for their assessments.
- **Key Features:**
  - Marks must be between 0 and 100.
  - Indices on `student_id` and `subject_id` for quick lookup.

### Attendance
- **Table:** `attendance`
- **Description:** Logs student attendance for each subject and date.
- **Key Features:**
  - Status restricted to 'Present', 'Absent', or 'Leave'.
  - Indices on `student_id` and `subject_id`.

### Payments / Fees
- **Table:** `payments`
- **Description:** Records fee and payment transactions (tuition, hostel, library, etc.).
- **Key Features:**
  - Amounts are checked to be non-negative.
  - Index on `student_id`.

### User Login System
- **Table:** `users`
- **Description:** Supports an optional academic portal with authentication for students, faculties, and admins.
- **Key Features:**
  - Unique username constraint.
  - `reference_id` to link with either a student or faculty record.
  - Role designated to the type of portal user.

---

## Installation & Setup

1. **Prerequisites:**
   - PostgreSQL installed.
   - Access to a SQL client (e.g., psql, PgAdmin).

2. **Setup Instructions:**
   - Create a new PostgreSQL database.
   - Run the provided SQL script (entire schema) to create all tables:
     ```bash
     psql -U your_username -d your_database -f schema.sql
     ```
   - Ensure that appropriate roles and user permissions are set up, especially if using the authentication system.

3. **Testing:**
   - Optionally, insert test data for each module to verify the design.
   - Use sample `INSERT` statements provided in additional documentation or test scripts.

---

## Future Extensions

While the current schema is comprehensive, consider the following enhancements for future versions:
- **Triggers & Procedures:** For automated calculations (e.g., fine for overdue library books, automatic attendance status updates).
- **Views & Reports:** For common queries like student performance summaries, fee reports, attendance statistics.
- **Security Enhancements:** Encrypted storage for sensitive data such as `password_hash` and refined user management.
- **API Integration:** Exposing the database functions through RESTful endpoints for web or mobile applications.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Contributing

Contributions are welcome! If you wish to suggest improvements, submit a pull request or open an issue in the repository.

---

*For further questions or feedback, please contact the repository maintainer.*
