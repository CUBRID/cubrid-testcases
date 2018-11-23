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
SELECT CUME_DIST(60, 70, 'D')
WITHIN GROUP(ORDER BY math, english, pe) AS cume
FROM scores
) select * from cte;

create table foo2 as
with cte as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
) select * from cte;

create table foo3 as
with cte as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
)select * from cte;

describe foo1;
describe foo2;
describe foo3;

--insert
insert into foo1
with cte as
(
SELECT CUME_DIST(60, 70, 'D')
WITHIN GROUP(ORDER BY math, english, pe) AS cume
FROM scores
) select * from cte;

insert into foo2
with cte as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
) select * from cte;

insert into foo3
with cte as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
)select * from cte;

select * from foo1 order by 1;
select * from foo2 order by 1,2,3,4,5,6;
select * from foo3 order by 1,2,3,4,5,6;


--delete
with cte1 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
),
 cte2 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
) delete foo2 from cte1,cte2,foo2 where cte1.id=cte2.id and cte1.cume_dist=cte2.cume_dist and foo2.id=cte2.id;

with cte1 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
),
 cte2 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
) delete from foo3 
where foo3.id=any(select id from cte2) 
and foo3.cume_dist=any(select cte1.cume_dist from cte1,cte2 where cte1.id=cte2.id);

select * from foo2 order by 1,2,3,4,5,6;
select * from foo3 order by 1,2,3,4,5,6;

with cte1 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
),
 cte2 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
) delete from foo3
where foo3.id in (select id from cte2)
and foo3.math in (select math from cte1);

select * from foo2 order by 1,2,3,4,5,6;
select * from foo3 order by 1,2,3,4,5,6;


replace into foo2
with cte as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
) select * from cte;

insert into foo3
with cte as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
)select * from cte;

with cte1 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
),
 cte2 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
) delete from foo3 where foo3.id=any(select id from cte2) and foo3.cume_dist=any(select cume_dist from cte1 where cte1.id=any(select id from cte2));


select * from foo2 order by 1,2,3,4,5,6;
select * from foo3 order by 1,2,3,4,5,6;


with cte1 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
),
 cte2 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
) update foo2 set id=-1
where foo2.id in (select id from cte2)
and foo2.math in (select math from cte1);

select * from foo2 order by 1,2,3,4,5,6;

with cte1 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY cume_dist
),
 cte2 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
) update foo2 set id=-2
where exists(
 with cte3 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist
FROM scores
ORDER BY grade, cume_dist
) select * from cte3
)
and exists (
with cte4 as
(
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
from scores
ORDER BY cume_dist
) select * from cte4
) and exists (
with cte5 as
(
 select * from foo3
)
SELECT id, math, english, pe, grade, CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist
from cte5
ORDER BY cume_dist
);

select * from foo2 order by 1,2,3,4,5,6;
select * from foo3 order by 1,2,3,4,5,6;

drop table if exists scores,foo1,foo2,foo3;
