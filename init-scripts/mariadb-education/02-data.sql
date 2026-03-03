-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO teachers (first_name, last_name, email, phone, subject_specialization, hire_date, qualification, years_of_experience) VALUES
('Dr. Robert', 'Smith', 'robert.smith@school.edu', '+1-555-6101', 'Mathematics', '2015-08-15', 'PhD in Mathematics', 12),
('Prof. Emily', 'Johnson', 'emily.johnson@school.edu', '+1-555-6102', 'English Literature', '2016-09-01', 'MA in English', 10),
('Dr. Michael', 'Brown', 'michael.brown@school.edu', '+1-555-6103', 'Physics', '2014-01-10', 'PhD in Physics', 15),
('Ms. Sarah', 'Davis', 'sarah.davis@school.edu', '+1-555-6104', 'Chemistry', '2018-07-20', 'MSc in Chemistry', 8),
('Mr. David', 'Wilson', 'david.wilson@school.edu', '+1-555-6105', 'History', '2017-03-15', 'MA in History', 9),
('Dr. Lisa', 'Martinez', 'lisa.martinez@school.edu', '+1-555-6106', 'Biology', '2019-08-01', 'PhD in Biology', 6);
INSERT INTO students (first_name, last_name, email, phone, date_of_birth, enrollment_date, grade_level, guardian_name, guardian_phone) VALUES
('Alice', 'Anderson', 'alice.a@student.edu', '+1-555-7101', '2006-05-15', '2022-09-01', '11th Grade', 'John Anderson', '+1-555-7201'),
('Bob', 'Baker', 'bob.b@student.edu', '+1-555-7102', '2006-08-22', '2022-09-01', '11th Grade', 'Mary Baker', '+1-555-7202'),
('Carol', 'Clark', 'carol.c@student.edu', '+1-555-7103', '2007-03-10', '2023-09-01', '10th Grade', 'Robert Clark', '+1-555-7203'),
('Daniel', 'Davis', 'daniel.d@student.edu', '+1-555-7104', '2006-11-30', '2022-09-01', '11th Grade', 'Susan Davis', '+1-555-7204'),
('Emma', 'Evans', 'emma.e@student.edu', '+1-555-7105', '2007-07-18', '2023-09-01', '10th Grade', 'James Evans', '+1-555-7205'),
('Frank', 'Foster', 'frank.f@student.edu', '+1-555-7106', '2006-02-25', '2022-09-01', '11th Grade', 'Linda Foster', '+1-555-7206'),
('Grace', 'Green', 'grace.g@student.edu', '+1-555-7107', '2007-09-12', '2023-09-01', '10th Grade', 'Michael Green', '+1-555-7207'),
('Henry', 'Harris', 'henry.h@student.edu', '+1-555-7108', '2006-12-05', '2022-09-01', '11th Grade', 'Patricia Harris', '+1-555-7208');
INSERT INTO courses (course_code, course_name, description, credits, teacher_id, semester, academic_year, max_students, schedule) VALUES
('MATH-301', 'Advanced Calculus', 'Advanced topics in calculus and analysis', 4, 1, 'Spring', '2023-2024', 30, 'Mon/Wed 9:00-10:30'),
('ENG-201', 'English Literature', 'Survey of British and American literature', 3, 2, 'Spring', '2023-2024', 35, 'Tue/Thu 10:00-11:30'),
('PHY-401', 'Quantum Physics', 'Introduction to quantum mechanics', 4, 3, 'Spring', '2023-2024', 25, 'Mon/Wed 13:00-14:30'),
('CHEM-301', 'Organic Chemistry', 'Fundamentals of organic chemistry', 4, 4, 'Spring', '2023-2024', 28, 'Tue/Thu 14:00-15:30'),
('HIST-201', 'World History', 'Modern world history from 1500 to present', 3, 5, 'Spring', '2023-2024', 40, 'Wed/Fri 11:00-12:30'),
('BIO-301', 'Molecular Biology', 'Cell and molecular biology', 4, 6, 'Spring', '2023-2024', 30, 'Mon/Wed 15:00-16:30');
INSERT INTO enrollments (student_id, course_id, enrollment_date, status, grade, attendance_percentage) VALUES
(1, 1, '2024-01-15', 'enrolled', 'A', 95.5),
(1, 2, '2024-01-15', 'enrolled', 'A-', 92.0),
(2, 1, '2024-01-15', 'enrolled', 'B+', 88.5),
(2, 3, '2024-01-15', 'enrolled', 'A', 94.0),
(3, 2, '2024-01-15', 'enrolled', 'B', 85.0),
(3, 5, '2024-01-15', 'enrolled', 'A-', 90.5),
(4, 1, '2024-01-15', 'enrolled', 'A', 96.0),
(4, 4, '2024-01-15', 'enrolled', 'B+', 87.5),
(5, 5, '2024-01-15', 'enrolled', 'A', 93.0),
(6, 3, '2024-01-15', 'enrolled', 'B', 86.0);
INSERT INTO assignments (course_id, assignment_name, description, due_date, max_points, assignment_type) VALUES
(1, 'Calculus Problem Set 1', 'Integration and differentiation problems', '2024-02-15', 100, 'homework'),
(1, 'Midterm Project', 'Applied calculus project', '2024-03-20', 200, 'project'),
(2, 'Literary Analysis Essay', 'Analysis of Shakespeare play', '2024-02-28', 100, 'essay'),
(3, 'Quantum Mechanics Lab', 'Laboratory experiment on wave-particle duality', '2024-03-10', 150, 'lab'),
(4, 'Organic Synthesis Report', 'Report on organic compound synthesis', '2024-03-15', 100, 'report');
INSERT INTO submissions (assignment_id, student_id, submission_date, points_earned, feedback, graded_by) VALUES
(1, 1, '2024-02-14 18:30:00', 95, 'Excellent work! Minor error in problem 5.', 1),
(1, 2, '2024-02-15 10:00:00', 88, 'Good effort. Review integration by parts.', 1),
(1, 4, '2024-02-14 22:00:00', 97, 'Outstanding! Perfect understanding.', 1),
(3, 1, '2024-02-27 16:00:00', 92, 'Well-written analysis with good insights.', 2),
(3, 3, '2024-02-28 12:00:00', 85, 'Good work. Expand on character development.', 2);
INSERT INTO exams (course_id, exam_name, exam_date, duration_minutes, total_marks, exam_type) VALUES
(1, 'Calculus Midterm Exam', '2024-03-05', 120, 100, 'midterm'),
(2, 'Literature Midterm Exam', '2024-03-08', 90, 100, 'midterm'),
(3, 'Physics Midterm Exam', '2024-03-12', 120, 100, 'midterm'),
(4, 'Chemistry Midterm Exam', '2024-03-15', 120, 100, 'midterm');
INSERT INTO exam_results (exam_id, student_id, marks_obtained, grade, remarks) VALUES
(1, 1, 92, 'A', 'Excellent performance'),
(1, 2, 85, 'B+', 'Good work'),
(1, 4, 95, 'A', 'Outstanding'),
(2, 1, 88, 'A-', 'Very good'),
(2, 3, 82, 'B', 'Good effort');
INSERT INTO attendance (student_id, course_id, attendance_date, status) VALUES
(1, 1, '2024-03-01', 'present'),
(1, 1, '2024-03-04', 'present'),
(2, 1, '2024-03-01', 'present'),
(2, 1, '2024-03-04', 'absent'),
(3, 2, '2024-03-05', 'present'),
(4, 1, '2024-03-01', 'present');
