SELECT ROUND(LAT_N,4)
FROM( -- Start of the subquery
  SELECT
   --1.Assigns a sequential row number to each station
      ROW_NUMBER() OVER (ORDER BY LAT_N) AS station_rank,
      LAT_N,
    --Calculates the expected rank number (n) for the median
      (((SELECT COUNT(*) FROM STATION) + 1) / 2) AS n
  FROM
      STATION) as subquery
-- select only the row matches the calculated median position (n)
 WHERE station_rank = n



-- VER 2---------------------------------------------
 
SELECT 
    ROUND(S.LAT_N, 4) 
FROM STATION S 
WHERE 
     -- Subquery 1: Counts the number of LAT_N values 
     -- strictly GREATER THAN the current candidate (S.LAT_N).
    (SELECT COUNT(*) 
     FROM  STATION 
     WHERE  LAT_N > S.LAT_N ) 
    
    = --Number of elements above must equal number of elements below.
    
    -- Subquery 2: Counts the number of LAT_N values 
    --strictly LESS THAN the current candidate (S.LAT_N).
    (SELECT COUNT(*) 
     FROM STATION  
     WHERE LAT_N < S.LAT_N )
    
