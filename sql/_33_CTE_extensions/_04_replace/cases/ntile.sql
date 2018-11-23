
drop table if exists t1,t2,foo1,foo2;
CREATE TABLE t1(name VARCHAR(10), birthdate DATE);
INSERT INTO t1 VALUES
    ('Amie', date'1978-03-18'),
    ('Jane', date'1983-05-12'),
    ('Lora', date'1987-03-26'),
    ('James', date'1948-12-28'),
    ('Peter', date'1988-10-25'),
    ('Tom', date'1980-07-28'),
    ('Ralph', date'1995-03-17'),
    ('David', date'1986-07-28');

--create
create table foo1 as
with cte as
(
 SELECT name, birthdate, NTILE(5) OVER (ORDER BY birthdate) age_group FROM t1
) select * from cte; 


CREATE TABLE t2(name VARCHAR(10), score INT);
INSERT INTO t2 VALUES
    ('Amie', 60),
    ('Jane', 80),
    ('Lora', 60),
    ('James', 75),
    ('Peter', 70),
    ('Tom', 30),
    ('Ralph', 99),
    ('David', 55);

--create    
create table foo2 as
with cte as
(
 SELECT name, score, NTILE(5) OVER (ORDER BY score DESC) grade FROM t2 ORDER BY name
) select * from cte;

describe foo1;
describe foo2;

--insert
insert into foo1
with cte as
(
 SELECT name, birthdate, NTILE(5) OVER (ORDER BY birthdate) age_group FROM t1
) select * from cte;

insert into foo1
with cte as
(
 select * from t1
) SELECT name, birthdate, NTILE(5) OVER (ORDER BY birthdate) age_group FROM cte;

insert into foo2
with cte as
(
 SELECT name, score, NTILE(5) OVER (ORDER BY score DESC) grade FROM t2 ORDER BY name
) select * from cte;


insert into foo2
with cte as
(
 select * from t2
) SELECT name, score, NTILE(5) OVER (ORDER BY score DESC) grade FROM cte ORDER BY name;

select * from foo1;
select * from foo2;

--update
with cte as
(
 SELECT name, birthdate, NTILE(5) OVER (ORDER BY birthdate) age_group FROM t1
) update foo1,cte set foo1.name=foo1.name||'up' where foo1.birthdate=cte.birthdate and foo1.name=cte.name and foo1.age_group=cte.age_group ;

with cte as
(
 SELECT name, score, NTILE(5) OVER (ORDER BY score DESC) grade FROM t2 ORDER BY name
) update foo2,cte set foo2.name=foo2.name||'upd' where foo2.name=cte.name and foo2.score=cte.score and foo2.grade=cte.grade;

select * from foo1;
select * from foo2;


--delete
with cte as
(
 SELECT name, birthdate, NTILE(5) OVER (ORDER BY birthdate) age_group FROM t1
) delete foo1 from foo1,cte where foo1.birthdate=cte.birthdate  and foo1.age_group=cte.age_group ;

with cte as
(
 SELECT name, score, NTILE(5) OVER (ORDER BY score DESC) grade FROM t2 ORDER BY name
) delete foo2 from  foo2,cte where foo2.score=cte.score and foo2.grade=cte.grade;

select * from foo1;
select * from foo2;

--replace
replace into foo1
with cte as
(
 SELECT name, birthdate, NTILE(5) OVER (ORDER BY birthdate) age_group FROM t1
) select * from cte;

replace into foo1
with cte as
(
 select * from t1
) SELECT name, birthdate, NTILE(5) OVER (ORDER BY birthdate) age_group FROM cte;

replace into foo2
with cte as
(
 SELECT name, score, NTILE(5) OVER (ORDER BY score DESC) grade FROM t2 ORDER BY name
) select * from cte;

replace  into foo2
with cte as
(
 select * from t2
) SELECT name, score, NTILE(5) OVER (ORDER BY score DESC) grade FROM cte ORDER BY name;

select * from foo1;
select * from foo2;
