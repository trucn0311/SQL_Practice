-- OUTER QUERY: The final SELECT statement
SELECT 
    -- 1. Conditional Naming (Equivalent to CASE WHEN G.Grade >= 8 THEN S.Name ELSE 'NULL' END)
    -- This handles the requirement to display "NULL" for students with Grade < 8.
    IF(g >= 8, sub.Name, 'NULL') AS n,
    
    -- 2. Select the calculated Grade
    g, 
    
    -- 3. Select the student's raw Marks
    sub.Marks
    
FROM
    -- INNER SUBQUERY (s): This calculates the grade for every student first.
    (
        SELECT 
            Students.Name, 
            
            -- This is the Scalar Subquery: It executes for every student row, 
            -- performing an implicit join (correlation) to find the single matching Grade.
            (
                SELECT grades.grade 
                FROM grades 
                -- Correlation: Links the current student's Marks to the appropriate grade range
                WHERE students.marks >= grades.min_mark 
                  AND students.marks <= grades.max_mark
            ) AS g, -- Alias 'g' is the calculated Grade
            
            Students.Marks
        FROM Students -- Driving table
    ) AS sub -- Alias the result set as 's'

-- FINAL ORDERING: Achieves the complex, conditional sorting using three simple keys.
ORDER BY 
    -- Key 1: Primary Sort
    -- Puts students with higher grades first (e.g., Grade 10, then 9, then 8).
    g DESC, 
    
    -- Key 2: Secondary Sort (The clever part for names/separation)
    -- a) For Grade >= 8, it sorts by the actual name alphabetically (ASC).
    -- b) For Grade < 8 (where 'n' is "NULL"), it pushes these rows to the end of the current grade group.
    n ASC, 
    
    -- Key 3: Tertiary Sort
    -- This key only takes effect when both Grade (g) and Name (n) are tied (i.e., when n = "NULL").
    -- This correctly orders the low-grade students (Grade < 8) by their Marks (ASC).
    sub.Marks ASC;