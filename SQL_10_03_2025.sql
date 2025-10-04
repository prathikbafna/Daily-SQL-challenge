/*

3188. Find Top Scoring Students II

Hard

Table: students

+-------------+----------+
| Column Name | Type     | 
+-------------+----------+
| student_id  | int      |
| name        | varchar  |
| major       | varchar  |
+-------------+----------+
student_id is the primary key for this table. 
Each row contains the student ID, student name, and their major.
Table: courses

+-------------+-------------------+
| Column Name | Type              |       
+-------------+-------------------+
| course_id   | int               |    
| name        | varchar           |      
| credits     | int               |           
| major       | varchar           |       
| mandatory   | enum              |      
+-------------+-------------------+
course_id is the primary key for this table. 
mandatory is an enum type of ('Yes', 'No').
Each row contains the course ID, course name, credits, major it belongs to, and whether the course is mandatory.
Table: enrollments

+-------------+----------+
| Column Name | Type     | 
+-------------+----------+
| student_id  | int      |
| course_id   | int      |
| semester    | varchar  |
| grade       | varchar  |
| GPA         | decimal  | 
+-------------+----------+
(student_id, course_id, semester) is the primary key (combination of columns with unique values) for this table.
Each row contains the student ID, course ID, semester, and grade received.
Write a solution to find the students who meet the following criteria:

Have taken all mandatory courses and at least two elective courses offered in their major.
Achieved a grade of A in all mandatory courses and at least B in elective courses.
Maintained an average GPA of at least 2.5 across all their courses (including those outside their major).
Return the result table ordered by student_id in ascending order.

*/

WITH StudentGrades AS (
    SELECT e.student_id, e.course_id, e.grade, c.major
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
),
StudentGPA AS (
    SELECT student_id, AVG(GPA) AS avg_gpa
    FROM enrollments
    GROUP BY student_id
),
EligibleStudents AS (
    SELECT s.student_id
    FROM students s
    JOIN StudentGPA g ON s.student_id = g.student_id
    WHERE g.avg_gpa >= 2.5
      AND NOT EXISTS (
          SELECT 1
          FROM courses m
          WHERE m.major = s.major AND m.mandatory = 'Yes'
          AND NOT EXISTS (
              SELECT 1
              FROM StudentGrades sg
              WHERE sg.student_id = s.student_id
              AND sg.course_id = m.course_id
              AND sg.grade = 'A'
          )
      )
      AND (
          SELECT COUNT(DISTINCT seg.course_id)
          FROM StudentGrades seg
          JOIN courses el ON seg.course_id = el.course_id
          WHERE seg.student_id = s.student_id
            AND el.major = s.major
            AND seg.grade IN ('A', 'B') AND el.mandatory = 'No'
      ) >= 2
)
SELECT student_id
FROM EligibleStudents
ORDER BY student_id;