DROP TABLE IF EXISTS cbrd_cte;
CREATE TABLE cbrd_cte( 
  a int(10) NOT NULL, 
  b int(10) NOT NULL, 
  PRIMARY KEY (a,b), 
  KEY b(b) 
); 
INSERT INTO cbrd_cte VALUES 
            ( 1,3) , (2,1), (2,4) ,(3,4 ), (3,5), (3,6),(4,7) , (5,1), ( 5,6), ( 6,1 );
DROP VIEW IF EXISTS cbrd_cte2;
CREATE VIEW cbrd_cte2 ( a, b ) 
            AS 
SELECT a, 
       b 
FROM   cbrd_cte 
UNION ALL 
SELECT b, 
       a 
FROM   cbrd_cte;
WITH recursive transitive_closure(a, b, distance, path_string) AS 
( 
       SELECT a, 
              b, 
              1                             AS distance, 
                     concat(a, '.', b, '.') AS path_string 
       FROM   cbrd_cte 
       UNION ALL 
       SELECT tc.a, 
              e.b, 
              tc.distance +                              1, 
                     concat(tc.path_string, e.b, '.') AS path_string 
       FROM   cbrd_cte                                   AS e 
       JOIN   transitive_closure                      AS tc 
       ON     e.a <> tc.b 
       AND    1=0 
       AND    1=1 ) 
SELECT   * 
FROM     transitive_closure 
ORDER BY a, 
         b, 
         distance;

DROP VIEW IF EXISTS cbrd_cte2;
DROP TABLE IF EXISTS cbrd_cte;
