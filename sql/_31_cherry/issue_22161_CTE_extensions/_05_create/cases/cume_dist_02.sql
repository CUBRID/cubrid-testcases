drop table if exists scores,foo1,foo2,foo3;
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

create table foo1 as
with cte as
(
  select * from scores
)
SELECT CUME_DIST(60, 70, 'D')
WITHIN GROUP(ORDER BY math, english, pe) AS cume
FROM cte;

create table foo2 as
with cte as
(
    select * from scores
)
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM cte
ORDER BY cume_dist;

create table foo3 as
with cte as
(
    select * from scores
) 
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM cte
ORDER BY grade, cume_dist;

describe foo1;
describe foo2;
describe foo3;
drop table if exists scores,foo1,foo2,foo3;
