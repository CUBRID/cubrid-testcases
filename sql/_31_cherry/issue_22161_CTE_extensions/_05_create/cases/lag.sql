drop table if exists t_emp,foo1;
CREATE TABLE t_emp (name VARCHAR(10), empno INT);
INSERT INTO t_emp VALUES
    ('Amie', 11011),
    ('Jane', 13077),
    ('Lora', 12045);

create table foo1 as
with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
) select * from (select * from cte) x;

select * from foo1 order by 1,2,3;

--insert
insert into foo1
with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
) select * from (select * from cte) x;

insert into foo1
with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
) SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM cte;

select * from foo1 order by 1,2,3;

--delete
with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
) delete from foo1 where prev_empno =any(
with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
) SELECT  LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM cte);

select * from foo1 order by 1,2,3;


with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
)  delete from foo1 where prev_empno=(SELECT LAG (empno, 1) OVER (ORDER BY empno) prev_empno FROM cte where prev_empno is null) ;

select * from foo1 order by 1,2,3;

with cte as
(select prev_empno from foo1)
delete from foo1 using foo1,cte where cte.prev_empno is null;

select * from foo1 order by 1,2,3;

--replace
replace into foo1
with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
) SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM cte;


select * from foo1 order by 1,2,3;

--update
with cte as
(
 SELECT name, empno, LAG (empno, 1) OVER (ORDER BY empno) prev_empno
 FROM t_emp
) update foo1,cte
set foo1.name=foo1.name||'A'
where 2<(select count(*) from cte)
and cte.prev_empno is not null;

select * from foo1 order by 1,2,3;

drop table if exists t_emp,foo1;
