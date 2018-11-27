drop table if exists t1,t2,foo1,foo2,foo3;

CREATE TABLE t1 (name VARCHAR(10), empno INT);
INSERT INTO t1 VALUES
('Amie', 11011), ('Jane', 13077), ('Lora', 12045), ('James', 12006),
('Peter', 14006), ('Tom', 12786), ('Ralph', 23518), ('David', 55);

create table foo1 as
with cte as
(
SELECT name, empno, LEAD (empno, 1) OVER (ORDER BY empno) next1no
FROM t1
) select * from cte;


CREATE TABLE t2 (num INT, title VARCHAR(50));
INSERT INTO t2 VALUES
(1, 'title 1'), (2, 'title 2'), (3, 'title 3'), (4, 'title 4'), (5, 'title 5'), (6, 'title 6'), (7, 'title 7');

create table foo2 as
with cte as
(
SELECT num, title,
    LEAD (title,1,'no next page') OVER (ORDER BY num) next_title,
    LAG (title,1,'no previous page') OVER (ORDER BY num) prev_title
FROM t2
)select * from cte;

create table foo3  as
with cte as
(
SELECT * FROM
 (
    SELECT num, title,
        LEAD(title,1,'no next page') OVER (ORDER BY num) next_title,
        LAG(title,1,'no previous page') OVER (ORDER BY num) prev_title
    FROM t2
 ) WHERE num=5
)select * from cte;


describe foo1;
describe foo2;
describe foo3;

--insert 
insert into foo1
with cte as
(
SELECT name, empno, LEAD (empno, 1) OVER (ORDER BY empno) next1no
FROM t1
) select * from cte;


insert into foo2
with cte as
(
SELECT num, title,
    LEAD (title,1,'no next page') OVER (ORDER BY num) next_title,
    LAG (title,1,'no previous page') OVER (ORDER BY num) prev_title
FROM t2
)select * from cte;

insert into foo3
with cte as
(
SELECT * FROM
 (
    SELECT num, title,
        LEAD(title,1,'no next page') OVER (ORDER BY num) next_title,
        LAG(title,1,'no previous page') OVER (ORDER BY num) prev_title
    FROM t2
 ) WHERE num=5
)select * from cte;

select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;
select * from foo3 order by 1,2,3;


--delete
with cte as
(
SELECT name, empno, LEAD (empno, 1) OVER (ORDER BY empno) next1no
FROM t1
) delete foo1 from foo1 inner join cte on foo1.name=cte.name
where foo1.next1no in (select empno from cte);


with cte as
(
SELECT num, title,
    LEAD (title,1,'no next page') OVER (ORDER BY num) next_title,
    LAG (title,1,'no previous page') OVER (ORDER BY num) prev_title
FROM t2
) delete foo2 from foo2,cte where foo2.num=cte.num
and  foo2.next_title in (select title from cte);

with cte as
(
SELECT * FROM
 (
    SELECT num, title,
        LEAD(title,1,'no next page') OVER (ORDER BY num) next_title,
        LAG(title,1,'no previous page') OVER (ORDER BY num) prev_title
    FROM t2
 ) WHERE num=5
)delete foo3 from foo3,cte where foo3.num=cte.num
and  foo3.next_title not in (select title from cte);

select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;
select * from foo3 order by 1,2,3;

with cte as
(select * from t1) delete from foo1 where exists (select count(name) from cte);

with cte as
(select * from t2) delete from foo2 where exists (select count(num) from cte);

with cte as
(select * from t2) delete from foo3 where exists (select count(num) from cte);

--replace
replace into foo1
with cte as
(
SELECT name, empno, LEAD (empno, 1) OVER (ORDER BY empno) next1no
FROM t1
) select * from cte;

replace into foo1
with cte as
(select * from t1)
SELECT name, empno, LEAD (empno, 1) OVER (ORDER BY empno) next1no
FROM cte;

replace into foo2
with cte as
(
SELECT num, title,
    LEAD (title,1,'no next page') OVER (ORDER BY num) next_title,
    LAG (title,1,'no previous page') OVER (ORDER BY num) prev_title
FROM t2
)select * from cte;

replace into foo2
with cte as
( select * from t2)
SELECT num, title,
    LEAD (title,1,'no next page') OVER (ORDER BY num) next_title,
    LAG (title,1,'no previous page') OVER (ORDER BY num) prev_title
FROM cte;

replace into foo3
with cte as
(
SELECT * FROM
 (
    SELECT num, title,
        LEAD(title,1,'no next page') OVER (ORDER BY num) next_title,
        LAG(title,1,'no previous page') OVER (ORDER BY num) prev_title
    FROM t2
 ) WHERE num=5
)select * from cte;

replace into foo3
with cte as
(select * from t2)
SELECT * FROM
 (
    SELECT num, title,
        LEAD(title,1,'no next page') OVER (ORDER BY num) next_title,
        LAG(title,1,'no previous page') OVER (ORDER BY num) prev_title
    FROM cte
 ) WHERE num=5;


select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;
select * from foo3 order by 1,2,3;

--update
with cte as
(
SELECT name, empno, LEAD (empno, 1) OVER (ORDER BY empno) next1no
FROM t1
) update foo1 inner join cte on foo1.name=cte.name
set foo1.empno=foo1.empno-10000
where foo1.next1no in (select empno from cte);


with cte as
(
SELECT num, title,
    LEAD (title,1,'no next page') OVER (ORDER BY num) next_title,
    LAG (title,1,'no previous page') OVER (ORDER BY num) prev_title
FROM t2
) update foo2,cte 
set foo2.num=foo2.num+100
where foo2.num=cte.num
and  foo2.next_title in (select title from cte);

with cte as
(
SELECT * FROM
 (
    SELECT num, title,
        LEAD(title,1,'no next page') OVER (ORDER BY num) next_title,
        LAG(title,1,'no previous page') OVER (ORDER BY num) prev_title
    FROM t2
 ) WHERE num=5
)update foo3,cte 
set foo3.num=foo3.num+100
where foo3.num=cte.num
and  foo3.next_title not in (select title from cte);

select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;
select * from foo3 order by 1,2,3;

drop table if exists foo1,foo2,foo3,t2;
