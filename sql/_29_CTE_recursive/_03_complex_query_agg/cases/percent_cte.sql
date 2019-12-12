drop if exists scores;
CREATE TABLE scores(id INT PRIMARY KEY AUTO_INCREMENT, math INT, english INT, pe CHAR, grade INT);
INSERT INTO scores(math, english, pe, grade)
       VALUES(60, 70, 'A', 1),
       (60, 70, 'A', 1),
       (60, 80, 'A', 1),
       (60, 70, 'B', 1),
       (70, 60, 'A', 1) ,
       (70, 70, 'A', 1) ,
       (80, 70, 'C', 1) ,
       (70, 80, 'C', 1),
       (85, 60, 'C', 1),
       (75, 90, 'B', 1);
INSERT INTO scores(math, english, pe, grade)
       VALUES(95, 90, 'A', 2),
       (85, 95, 'B', 2),
       (95, 90, 'A', 2),
       (85, 95, 'B', 2),
       (75, 80, 'D', 2),
       (75, 85, 'D', 2),
       (75, 70, 'C', 2),
       (65, 95, 'A', 2),
       (65, 95, 'A', 2),
       (65, 95, 'A', 2);
	  
with recursive cte as (select * from scores)	  SELECT PERCENT_RANK(60, 70, 'D')
WITHIN GROUP(ORDER BY math, english, pe) AS percent_rank
FROM cte;
with recursive cte as (select * from scores)	 SELECT id, math, english, pe, grade, PERCENT_RANK() OVER(ORDER BY math, english, pe) AS percent_rank
FROM cte
ORDER BY percent_rank, id;
with recursive cte as (select * from scores) SELECT id, math, english, pe, grade, PERCENT_RANK() OVER(PARTITION BY grade ORDER BY math, english, pe) AS percent_rank
FROM cte
ORDER BY grade, percent_rank, id;
drop if exists scores;
CREATE TABLE scores([id] INT PRIMARY KEY AUTO_INCREMENT, [math] INT, english INT, [class] CHAR);
INSERT INTO scores VALUES
       (1, 30, 70, 'A'),
       (2, 40, 70, 'A'),
       (3, 60, 80, 'A'),
       (4, 70, 70, 'A'),
       (5, 72, 60, 'A') ,
       (6, 77, 70, 'A') ,
       (7, 80, 70, 'C') ,
       (8, 70, 80, 'C'),
       (9, 85, 60, 'C'),
       (10, 78, 90, 'B'),
       (11, 95, 90, 'D'),
       (12, 85, 95, 'B'),
       (13, 95, 90, 'B'),
       (14, 85, 95, 'B'),
       (15, 75, 80, 'D'),
       (16, 75, 85, 'D'),
       (17, 75, 70, 'C'),
       (18, 65, 95, 'C'),
       (19, 65, 95, 'D'),
       (20, 65, 95, 'D');
with cte as (select * from scores) SELECT PERCENTILE_CONT(0.5)
WITHIN GROUP(ORDER BY math) AS pcont
FROM cte; 
with cte as (select * from scores) SELECT math, [class], PERCENTILE_CONT(0.5)
WITHIN GROUP(ORDER BY math)
OVER (PARTITION BY [class]) AS pcont
FROM cte;
with cte as (select * from scores) SELECT PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math) AS pdisc
FROM cte;
drop if exists scores;
