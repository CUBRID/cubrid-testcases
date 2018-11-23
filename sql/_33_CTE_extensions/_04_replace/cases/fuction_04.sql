drop table if exists scores,foo;
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

create table foo as
with cte as
(
SELECT PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math) AS pcont
FROM scores
) select * from cte;

select * from foo;

drop table if exists foo;
create table foo (i double);

insert into foo
with cte as
(
SELECT PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math) AS pcont
FROM scores
) select * from cte;

select * from foo;


with cte as
(
SELECT PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math) AS pcont
FROM scores
) delete from foo where i in (select * from cte);
select * from foo;

replace into foo
with cte as
(
SELECT PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math) AS pcont
FROM scores
) select * from cte;

select * from foo;


with cte as
(
SELECT PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math) AS pcont
FROM scores
) update foo set i=70 where i in (select * from cte);
select * from foo;



replace into foo
with cte as
(
SELECT math, [class], PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math)
OVER (PARTITION BY [class]) AS pcont
FROM scores
) select pcont from cte;

select * from foo;



with cte as
(
SELECT math, [class], PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math)
OVER (PARTITION BY [class]) AS pcont
FROM scores
) delete from foo where i in (select pcont from cte);
select * from foo;


with cte as
(
SELECT math, [class], PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math)
OVER (PARTITION BY [class]) AS pcont
FROM scores
) update foo set i=20 where i not in (select pcont from cte);
select * from foo;

insert into foo
with cte as
(
SELECT math, [class], PERCENTILE_DISC(0.5)
WITHIN GROUP(ORDER BY math)
OVER (PARTITION BY [class]) AS pcont
FROM scores
) select pcont from cte;

select * from foo;
