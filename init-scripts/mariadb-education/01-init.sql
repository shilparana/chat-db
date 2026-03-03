-- STUDENTS TABLE: Stores student enrollment and demographic information
-- Use this table for queries about: student names, emails, enrollment dates, grade levels, student status, guardians, student contact info
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each student
    first_name VARCHAR(100) NOT NULL,                  -- Student's first name
    last_name VARCHAR(100) NOT NULL,                   -- Student's last name
    email VARCHAR(255) UNIQUE NOT NULL,                -- Student email address
    phone VARCHAR(20),                                 -- Student phone number
    date_of_birth DATE,                                -- Student's date of birth
    enrollment_date DATE,                              -- Date student enrolled
    grade_level VARCHAR(20),                           -- Grade level (9th, 10th, 11th, 12th)
    status VARCHAR(20) DEFAULT 'active',               -- Student status (active, graduated, withdrawn)
    guardian_name VARCHAR(255),                        -- Parent/guardian name
    guardian_phone VARCHAR(20),                        -- Parent/guardian phone
    address TEXT                                       -- Student address
);

-- TEACHERS TABLE: Stores teacher/instructor information and qualifications
-- Use this table for queries about: teacher names, subjects, qualifications, hire dates, experience, active teachers
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each teacher
    first_name VARCHAR(100) NOT NULL,                  -- Teacher's first name
    last_name VARCHAR(100) NOT NULL,                   -- Teacher's last name
    email VARCHAR(255) UNIQUE NOT NULL,                -- Teacher email address
    phone VARCHAR(20),                                 -- Teacher phone number
    subject_specialization VARCHAR(100),               -- Subject area (Mathematics, English, Physics, etc.)
    hire_date DATE,                                    -- Date teacher was hired
    qualification VARCHAR(255),                        -- Degrees/certifications (PhD, MA, MSc, etc.)
    years_of_experience INT,                           -- Years of teaching experience
    is_active BOOLEAN DEFAULT TRUE                     -- Whether teacher is currently active
);

-- COURSES TABLE: Stores course offerings and schedules
-- Use this table for queries about: course names, course codes, credits, semesters, teachers, schedules, max enrollment
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each course
    course_code VARCHAR(50) UNIQUE NOT NULL,           -- Course code (e.g., MATH-301)
    course_name VARCHAR(255) NOT NULL,                 -- Course name
    description TEXT,                                  -- Course description
    credits INT,                                       -- Credit hours
    teacher_id INT,                                    -- Teacher assigned to course
    semester VARCHAR(20),                              -- Semester (Fall, Spring, Summer)
    academic_year VARCHAR(20),                         -- Academic year (e.g., 2023-2024)
    max_students INT,                                  -- Maximum enrollment capacity
    schedule VARCHAR(255),                             -- Class schedule (days/times)
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- ENROLLMENTS TABLE: Links students to courses with grades and attendance
-- Use this table for queries about: student enrollments, course registrations, grades, attendance percentages, enrollment status
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each enrollment
    student_id INT,                                    -- Student enrolled
    course_id INT,                                     -- Course enrolled in
    enrollment_date DATE,                              -- Date of enrollment
    status VARCHAR(20) DEFAULT 'enrolled',             -- Status (enrolled, completed, dropped)
    grade VARCHAR(5),                                  -- Final grade (A, A-, B+, B, etc.)
    attendance_percentage DECIMAL(5, 2),               -- Attendance percentage
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- ASSIGNMENTS TABLE: Stores course assignments and homework
-- Use this table for queries about: assignment names, due dates, max points, assignment types, course assignments
CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each assignment
    course_id INT,                                     -- Course this assignment belongs to
    assignment_name VARCHAR(255) NOT NULL,             -- Assignment name/title
    description TEXT,                                  -- Assignment description/instructions
    due_date DATE,                                     -- Due date
    max_points INT,                                    -- Maximum points possible
    assignment_type VARCHAR(50),                       -- Type (homework, project, essay, lab, report)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When assignment was created
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- SUBMISSIONS TABLE: Stores student assignment submissions and grades
-- Use this table for queries about: submission dates, points earned, feedback, graded assignments, student work
CREATE TABLE submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each submission
    assignment_id INT,                                 -- Assignment being submitted
    student_id INT,                                    -- Student who submitted
    submission_date TIMESTAMP,                         -- When submitted
    file_path VARCHAR(500),                            -- Path to submitted file
    points_earned INT,                                 -- Points earned/grade
    feedback TEXT,                                     -- Teacher feedback/comments
    graded_by INT,                                     -- Teacher who graded
    graded_at TIMESTAMP NULL,                          -- When graded
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (graded_by) REFERENCES teachers(teacher_id)
);

-- ATTENDANCE TABLE: Tracks student class attendance
-- Use this table for queries about: attendance dates, attendance status, present/absent records, class attendance
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each attendance record
    student_id INT,                                    -- Student
    course_id INT,                                     -- Course/class
    attendance_date DATE,                              -- Date of class
    status VARCHAR(20),                                -- Status (present, absent, late, excused)
    notes TEXT,                                        -- Additional notes
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- EXAMS TABLE: Stores exam/test information
-- Use this table for queries about: exam names, exam dates, exam duration, total marks, exam types, course exams
CREATE TABLE exams (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each exam
    course_id INT,                                     -- Course this exam belongs to
    exam_name VARCHAR(255) NOT NULL,                   -- Exam name
    exam_date DATE,                                    -- Date of exam
    duration_minutes INT,                              -- Exam duration in minutes
    total_marks INT,                                   -- Total possible marks/points
    exam_type VARCHAR(50),                             -- Type (midterm, final, quiz)
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- EXAM_RESULTS TABLE: Stores student exam scores and results
-- Use this table for queries about: exam scores, marks obtained, exam grades, student performance, test results
CREATE TABLE exam_results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each exam result
    exam_id INT,                                       -- Exam taken
    student_id INT,                                    -- Student who took exam
    marks_obtained INT,                                -- Marks/points earned
    grade VARCHAR(5),                                  -- Letter grade (A, B+, etc.)
    remarks TEXT,                                      -- Additional remarks/comments
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);










CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_courses_teacher ON courses(teacher_id);
CREATE INDEX idx_submissions_assignment ON submissions(assignment_id);
CREATE INDEX idx_exam_results_exam ON exam_results(exam_id);
