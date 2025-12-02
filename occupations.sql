SELECT
    COALESCE(MAX(CASE WHEN Occupation ='Doctor' THEN name END), 'NULL') as Doctor,
    COALESCE(MAX(CASE WHEN Occupation ='Professor' THEN name END), 'NULL') as Professor,
    COALESCE(MAX(CASE WHEN Occupation ='Singer' THEN name END), 'NULL') as Singer,
    COALESCE(MAX(CASE WHEN Occupation ='Actor' THEN name END), 'NULL') as Actor
FROM(
    SELECT
    Name,
    Occupation,
    ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY name) AS rn
    FROM Occupations
    ) as subquery
GROUP BY rn
ORDER BY rn ;
