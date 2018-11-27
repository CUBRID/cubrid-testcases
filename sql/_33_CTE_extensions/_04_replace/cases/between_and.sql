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
 SELECT * FROM tbl WHERE salary BETWEEN 3000000 AND 4000000
) select * from cte;

create table foo2 as
with cte as
(
 SELECT * FROM tbl WHERE (salary >= 3000000) AND (salary <= 4000000)
) select * from cte;


create table foo3 as
with cte as
(
 SELECT * FROM tbl WHERE salary NOT BETWEEN 3000000 AND 4000000
) select * from cte;

create table foo4 as
with cte as
(
 SELECT * FROM tbl WHERE name BETWEEN 'A' AND 'E'
)select * from cte;

describe foo1;
describe foo2;
describe foo3;
describe foo4;


--insert
insert into foo1 
with cte as
(
 SELECT * FROM tbl WHERE salary BETWEEN 3000000 AND 4000000
) select * from cte;

insert into foo2
with cte as
(
 SELECT * FROM tbl WHERE (salary >= 3000000) AND (salary <= 4000000)
) select * from cte;

insert into foo3
with cte as
(
 SELECT * FROM tbl WHERE salary NOT BETWEEN 3000000 AND 4000000
) select * from cte;

insert into foo4
with cte as
( 
 SELECT * FROM tbl WHERE name BETWEEN 'A' AND 'E'
)select * from cte;

select * from foo1 order by 1,2,3,4;
select * from foo2 order by 1,2,3,4;
select * from foo3 order by 1,2,3,4;
select * from foo4 order by 1,2,3,4;

--delete
with cte as
(
 SELECT * FROM tbl WHERE salary BETWEEN 3000000 AND 4000000
) delete from foo1 where exists(
with cte as
(select * from tbl) SELECT * FROM cte WHERE salary BETWEEN 3000000 AND 4000000
);

with cte as
(
 SELECT * FROM tbl WHERE (salary >= 3000000) AND (salary <= 4000000)
) delete from foo2 where exists(
with cte as
(select * from tbl)  SELECT * FROM cte WHERE (salary >= 3000000) AND (salary <= 4000000)
);

with cte as
(
 SELECT * FROM tbl WHERE salary NOT BETWEEN 3000000 AND 4000000
) delete from foo3 where exists (select * from cte);


with cte as
(
 SELECT * FROM tbl WHERE name BETWEEN 'A' AND 'E'
) delete from foo4 where not exists (select * from cte);

select * from foo1 order by 1,2,3,4;
select * from foo2 order by 1,2,3,4;
select * from foo3 order by 1,2,3,4;
select * from foo4 order by 1,2,3,4;


--replace
replace into foo1
with cte as
(
 SELECT * FROM tbl WHERE salary BETWEEN 3000000 AND 4000000
) select * from cte;

replace into foo2
with cte as
(
 SELECT * FROM tbl WHERE (salary >= 3000000) AND (salary <= 4000000)
) select * from cte;

replace into foo3
with cte as
(
 SELECT * FROM tbl WHERE salary NOT BETWEEN 3000000 AND 4000000
) select * from cte;

replace into foo4
with cte as
(
 SELECT * FROM tbl WHERE name BETWEEN 'A' AND 'E'
)select * from cte;

select * from foo1 order by 1,2,3,4;
select * from foo2 order by 1,2,3,4;
select * from foo3 order by 1,2,3,4;
select * from foo4 order by 1,2,3,4;

--update
with cte as
(
 SELECT * FROM tbl WHERE salary BETWEEN 3000000 AND 4000000
) update foo1 set id=id+100 where exists(
with cte as
(select * from tbl) SELECT * FROM cte WHERE salary BETWEEN 3000000 AND 4000000
);

with cte as
(
 SELECT * FROM tbl WHERE (salary >= 3000000) AND (salary <= 4000000)
) update foo2 set id=id+100 where exists(
with cte as
(select * from tbl)  SELECT * FROM cte WHERE (salary >= 3000000) AND (salary <= 4000000)
);

with cte as
(
 SELECT * FROM tbl WHERE salary NOT BETWEEN 3000000 AND 4000000
) update foo3 set id=id+100 where exists (select * from cte);


with cte as
(
 SELECT * FROM tbl WHERE name BETWEEN 'A' AND 'E'
) update foo4 set id=id+100 where not exists (select * from cte);

select * from foo1 order by 1,2,3,4;
select * from foo2 order by 1,2,3,4;
select * from foo3 order by 1,2,3,4;
select * from foo4 order by 1,2,3,4;

drop table if exists tbl,foo1,foo2,foo3,foo4;
