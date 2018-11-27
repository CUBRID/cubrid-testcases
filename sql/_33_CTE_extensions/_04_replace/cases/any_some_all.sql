drop table if exists tbl,foo1,foo2,foo3,foo4;
CREATE TABLE tbl (id int primary key, name char(10), dept_name VARCHAR, salary INT);
INSERT INTO tbl VALUES(1, 'Kim', 'devel', 4000000);
INSERT INTO tbl VALUES(2, 'Moy', 'sales', 3000000);
INSERT INTO tbl VALUES(3, 'Jones', 'sales', 5400000);
INSERT INTO tbl VALUES(4, 'Smith', 'devel', 5500000);
INSERT INTO tbl VALUES(5, 'Kim', 'account', 3800000);
INSERT INTO tbl VALUES(6, 'Smith', 'devel', 2400000);
INSERT INTO tbl VALUES(7, 'Brown', 'account', NULL);

--create
create table foo1 as
with cte as
(
 SELECT * FROM tbl WHERE dept_name = ANY{'devel','sales'}
) select * from cte;

create table foo2 as
with cte as
(
 SELECT * FROM tbl WHERE salary > ALL{3000000, 4000000, NULL}
) select * from cte;


create table foo3 as
with cte as
(
 SELECT * FROM tbl WHERE salary > ANY{3000000, 4000000, NULL}
) select * from cte;

create table foo4 as
with cte as
(
 SELECT * FROM tbl WHERE (
  (0.9 * salary) < ALL (SELECT salary FROM tbl
  WHERE dept_name = 'devel'))
)select * from cte;

describe foo1;
describe foo2;
describe foo3;
describe foo4;


--insert
insert into foo1
with cte as
(
 SELECT * FROM tbl WHERE dept_name = ANY{'devel','sales'}
) select * from cte;

insert into foo2
with cte as
(
 SELECT * FROM tbl WHERE salary > ALL{3000000, 4000000, NULL}
) select * from cte;


insert into foo3
with cte as
(
 SELECT * FROM tbl WHERE salary > ANY{3000000, 4000000, NULL}
) select * from cte;

insert into foo4
with cte as
(
 SELECT * FROM tbl WHERE (
  (0.9 * salary) < ALL (SELECT salary FROM tbl
  WHERE dept_name = 'devel'))
)select * from cte;

select * from foo1 order by 1,2,3,4;
select * from foo2  order by 1,2,3,4;
select * from foo3  order by 1,2,3,4;
select * from foo4  order by 1,2,3,4;

--delete
with cte as
(
 SELECT * FROM tbl WHERE dept_name = ANY{'devel','sales'}
) delete from foo1 where exists (
with cte as
 (
  select * from tbl  
 ) SELECT * FROM cte WHERE dept_name = ANY{'devel','sales'}
);


with cte as
(
 SELECT * FROM tbl WHERE salary > ALL{3000000, 4000000, NULL}
) delete foo2 from foo2,cte where foo2.id=cte.id and foo2.name=cte.name and foo2.dept_name=cte.dept_name and foo2.salary=cte.salary;


with cte as
(
 SELECT * FROM tbl WHERE salary > ANY{3000000, 4000000, NULL}
) delete foo3 from foo3,cte where foo3.id=cte.id and foo3.name=cte.name and foo3.dept_name=cte.dept_name and foo3.salary=cte.salary;

with cte as
(
 SELECT * FROM tbl WHERE (
  (0.9 * salary) < ALL (SELECT salary FROM tbl
  WHERE dept_name = 'devel'))
)delete foo4 from foo4,cte where foo4.id=cte.id and foo4.name=cte.name and foo4.dept_name=cte.dept_name and foo4.salary=cte.salary;

select * from foo1  order by 1,2,3,4;
select * from foo2  order by 1,2,3,4;
select * from foo3   order by 1,2,3,4;
select * from foo4  order by 1,2,3,4;


--replace
replace into foo1
with cte as
(
 SELECT * FROM tbl WHERE dept_name = ANY{'devel','sales'}
) select * from cte;

replace into foo2
with cte as
(
 SELECT * FROM tbl WHERE salary > ALL{3000000, 4000000, NULL}
) select * from cte;


replace into foo3
with cte as
(
 SELECT * FROM tbl WHERE salary > ANY{3000000, 4000000, NULL}
) select * from cte;

replace into foo4
with cte as
(
 SELECT * FROM tbl WHERE (
  (0.9 * salary) < ALL (SELECT salary FROM tbl
  WHERE dept_name = 'devel'))
)select * from cte;

select * from foo1  order by 1,2,3,4;
select * from foo2  order by 1,2,3,4;
select * from foo3  order by 1,2,3,4;
select * from foo4  order by 1,2,3,4;

--update
with cte as
(
 SELECT * FROM tbl WHERE dept_name = ANY{'devel','sales'}
) update foo1 set foo1.id=foo1.id+100 where exists (
with cte as
 (
  select * from tbl  
 ) SELECT * FROM cte WHERE dept_name = ANY{'devel','sales'}
);


with cte as
(
 SELECT * FROM tbl WHERE salary > ALL{3000000, 4000000, NULL}
) update foo2,cte  set foo2.id=foo2.id+100 where foo2.id=cte.id and foo2.name=cte.name and foo2.dept_name=cte.dept_name and foo2.salary=cte.salary;


with cte as
(
 SELECT * FROM tbl WHERE salary > ANY{3000000, 4000000, NULL}
) update foo3,cte set foo3.id=foo3.id+100 where foo3.id=cte.id and foo3.name=cte.name and foo3.dept_name=cte.dept_name and foo3.salary=cte.salary;

with cte as
(
 SELECT * FROM tbl WHERE (
  (0.9 * salary) < ALL (SELECT salary FROM tbl
  WHERE dept_name = 'devel'))
)update foo4,cte  set foo4.id=foo4.id+100 where foo4.id=cte.id and foo4.name=cte.name and foo4.dept_name=cte.dept_name and foo4.salary=cte.salary;

select * from foo1  order by 1,2,3,4;
select * from foo2  order by 1,2,3,4;
select * from foo3  order by 1,2,3,4;
select * from foo4  order by 1,2,3,4;

drop table if exists tbl,foo1,foo2,foo3,foo4;
