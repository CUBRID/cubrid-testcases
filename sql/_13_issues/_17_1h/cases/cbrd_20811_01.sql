drop if exists t; 
CREATE TABLE t (ID INT PRIMARY KEY, ParentID INT NULL, Description VARCHAR(100))
INSERT INTO t (ID, ParentID, Description) VALUES
(1, NULL, 'Parent'),(2, 1, 'Child'), (3, 2, 'SubChild');

WITH RecursiveCTE (StartingID, Levelz, Parents, Loopz, ID, ParentID, Description) AS
(
    SELECT ID, 1, '|' + CAST(ID AS VARCHAR(10)) + '|', 0, t.* FROM t
    UNION ALL
    SELECT R.StartingID, R.Levelz + 1, 
        R.Parents + CAST(MT.ID AS VARCHAR(10)) + '|',
        CASE WHEN R.Parents LIKE '%|' + CAST(MT.ID AS VARCHAR(10)) + '|%' THEN 1 ELSE 0 END,
        MT.* FROM t MT INNER JOIN RecursiveCTE R ON R.ParentID = MT.ID AND R.Loopz = 0
)
SELECT StartingID, Levelz, Parents, MAX(Loopz) OVER (PARTITION BY StartingID) Loopz, ID, ParentID, Description 
    FROM RecursiveCTE 
    ORDER BY StartingID, Levelz;
drop if exists t; 
