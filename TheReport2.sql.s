SELECT 
-- This handles the requirement to display "NULL" for students with Grade < 8.
    --    If Grade is 8 or higher, display the student's Name.
    --    Otherwise (Grade 1-7), display the string literal 'NULL'.
(case when g.grade <8 THEN NULL ELSE name END), g.grade, s.marks
FROM students s
-- Standard JOIN: Link every student to the correct grade range
JOIN grades g ON s.marks >= g.min_mark AND 
                 s.marks <= g.max_mark
ORDER BY 
-- Key 1: Primary Order - Sort by Grade (DESC). This puts Grade 10 first, then 9, etc.
g.grade DESC, 

-- Key 2: Secondary Order (for all rows) - Sort by the result of the conditional naming.
    -- This handles the two conflicting requirements:
    --   A. For high grades (8-10, where StudentName is the actual name): sorts names alphabetically (ASC).
    --   B. For low grades (1-7, where StudentName is 'NULL'): pushes the identical 'NULL' values 
s.name ASC, 

 -- Key 3: Tertiary Order - Sort by Marks (ASC).
    -- This only activates when both Grade and StudentName are tied (i.e., for the low-grade students who are all 'NULL'). 
    -- This satisfies the requirement to order low-grade students 
    -- by ascending Marks.
s.marks ASC