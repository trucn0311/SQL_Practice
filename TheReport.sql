/*
- Name, Grade, Mark
- Names from (8 ~ 10) only, DESC order by grades
- if more than one in the same grade (8-10), order name alphabetically

-(1~7) names = "NULL", DESC order by grades
- if more than one in the same grade (1-7), order marks in ASC
*/

SELECT
    --Final 1: Name
    COALESCE(CASE WHEN subquery.Grade >= 8 THEN subquery.Name END, 'NULL') AS Name,
    -- Final 2: Grade
    subquery.Grade,
    -- Final 3: Marks
    subquery.Marks

FROM (
    SELECT
        S.Name,
        S.Marks,
        G.Grade,
        
        -- Key 1: Primary Sort Group
        -- 1 for High Grades (8-10) - Named Students
        -- 2 for Low Grades (1-7) - 'NULL' Students
        CASE WHEN G.Grade >= 8 THEN 1 ELSE 2 END AS SortGroup,
        
        -- Key 2: Secondary Sort Key for High Grades
        -- Only populated for named students; NULL otherwise. Used for alphabetical sorting.
        CASE WHEN G.Grade >= 8 THEN S.Name END AS SortByNameKey,
        
        -- Key 3: Secondary Sort Key for Low Grades
        -- Only populated for 'NULL' students; NULL otherwise. Used for ascending Marks sorting.
        CASE WHEN G.Grade < 8 THEN S.Marks END AS SortByMarksKey

    FROM
        Students S
    JOIN
        Grades G ON S.Marks BETWEEN G.Min_Mark AND G.Max_Mark
    ) AS subquery

-- FINAL ORDERING: This must reference the keys calculated in the inner query (T)
ORDER BY 
 -- 1. SortGroup: Separates the two main sections (Named students first, then NULL students)
    subquery.SortGroup ASC,
    
    -- 2. Grade: Applies descending grade order across the whole result
    subquery.Grade DESC,
    
    -- 3. SortByNameKey: Orders high-grade students alphabetically (ASC)
    --    This key is NULL for low-grade students, so it has no effect on them.
    SortByNameKey ASC,
    
    -- 4. SortByMarksKey: Orders low-grade students by Marks (ASC)
    --    This key is NULL for high-grade students, so it has no effect on them.
    SortByMarksKey ASC;
    
