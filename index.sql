-- ===========================
-- 📌 Departments
-- ===========================
create table departments (
  id bigint primary key generated always as identity,
  name text not null unique,
  building text
);

-- ===========================
-- 👨‍🏫 Faculties
-- ===========================
create table faculties (
  id bigint primary key generated always as identity,
  name text not null,
  department_id bigint references departments(id) on delete set null,
  position_title text,
  role_type text default 'faculty' check (role_type in ('faculty', 'HOD', 'admin'))
);
create index idx_faculties_department_id on faculties(department_id);

-- ===========================
-- 🧑‍🎓 Students
-- ===========================
create table students (
  id bigint primary key generated always as identity,
  name text not null,
  department_id bigint references departments(id) on delete set null,
  enrollment_year int check (enrollment_year >= 1900)
);
create index idx_students_department_id on students(department_id);

-- ===========================
-- 📚 Subjects
-- ===========================
create table subjects (
  id bigint primary key generated always as identity,
  name text not null,
  department_id bigint references departments(id) on delete set null,
  credits int check (credits > 0),
  constraint unique_subject_per_dept unique (name, department_id)
);
create index idx_subjects_department_id on subjects(department_id);

-- ===========================
-- 👨‍🏫📚 Faculty-Subject Assignments
-- ===========================
create table faculty_subjects (
  id bigint primary key generated always as identity,
  faculty_id bigint references faculties(id) on delete cascade,
  subject_id bigint references subjects(id) on delete cascade,
  constraint unique_faculty_subject_pair unique (faculty_id, subject_id)
);
create index idx_faculty_subjects_faculty_id on faculty_subjects(faculty_id);
create index idx_faculty_subjects_subject_id on faculty_subjects(subject_id);

-- ===========================
-- 🧑‍🎓📚 Student Enrollments
-- ===========================
create table enrollments (
  id bigint primary key generated always as identity,
  student_id bigint references students(id) on delete cascade,
  subject_id bigint references subjects(id) on delete cascade,
  enrollment_date date,
  constraint unique_enrollment unique (student_id, subject_id)
);
create index idx_enrollments_student_id on enrollments(student_id);
create index idx_enrollments_subject_id on enrollments(subject_id);

-- ===========================
-- 🏫 Classrooms
-- ===========================
create table classrooms (
  id bigint primary key generated always as identity,
  room_number text not null,
  building text,
  capacity int check (capacity > 0),
  constraint unique_room_per_building unique (room_number, building)
);

-- ===========================
-- 📖 Library Books
-- ===========================
create table library_books (
  id bigint primary key generated always as identity,
  book_title text not null,
  author text,
  isbn text unique
);

-- ===========================
-- 📕 Library Book Issues
-- ===========================
create table library_issues (
  id bigint primary key generated always as identity,
  student_id bigint references students(id) on delete cascade,
  book_id bigint references library_books(id) on delete cascade,
  issue_date date not null,
  return_date date
);
create index idx_library_issues_student_id on library_issues(student_id);
create index idx_library_issues_book_id on library_issues(book_id);

-- ===========================
-- 🍽️ Canteen
-- ===========================
create table canteen (
  id bigint primary key generated always as identity,
  item_name text not null,
  price numeric(5, 2) check (price >= 0)
);

-- ===========================
-- 📝 Grades / Marks
-- ===========================
create table grades (
  id bigint primary key generated always as identity,
  student_id bigint references students(id) on delete cascade,
  subject_id bigint references subjects(id) on delete cascade,
  marks numeric(5,2) check (marks >= 0 and marks <= 100),
  exam_date date
);
create index idx_grades_student_id on grades(student_id);
create index idx_grades_subject_id on grades(subject_id);

-- ===========================
-- 📆 Attendance
-- ===========================
create table attendance (
  id bigint primary key generated always as identity,
  student_id bigint references students(id) on delete cascade,
  subject_id bigint references subjects(id) on delete cascade,
  date date not null,
  status text check (status in ('Present', 'Absent', 'Leave'))
);
create index idx_attendance_student_id on attendance(student_id);
create index idx_attendance_subject_id on attendance(subject_id);

-- ===========================
-- 💰 Payments / Fees
-- ===========================
create table payments (
  id bigint primary key generated always as identity,
  student_id bigint references students(id) on delete cascade,
  amount numeric(10, 2) check (amount >= 0),
  payment_date date not null,
  type text check (type in ('Tuition', 'Hostel', 'Library', 'Other'))
);
create index idx_payments_student_id on payments(student_id);

-- ===========================
-- 👤 User Login System (Optional for portal)
-- ===========================
create table users (
  id bigint primary key generated always as identity,
  username text not null unique,
  password_hash text not null,
  role text check (role in ('student', 'faculty', 'admin')) not null,
  reference_id bigint -- points to student_id or faculty_id
);
