drop table if exists tree,foo;
CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);

INSERT INTO tree VALUES (1,NULL,'Kim', 1963);
INSERT INTO tree VALUES (2,NULL,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,6,'Brown', 1981);



create table foo as
with cte as
(
SELECT id, mgrid, name
FROM tree
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id
)
SELECT id, mgrid, name
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;

insert into foo
with cte as
(
SELECT id, mgrid, name
FROM tree
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id
)
SELECT id, mgrid, name
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;
select * from foo  order by 1,2,3;


replace into foo
with cte as
(
SELECT id, mgrid, name
FROM tree
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id
)
SELECT id, mgrid, name
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;
select * from foo  order by 1,2,3;

select * from foo  order by 1,2,3;




with cte as
(
select * from tree
)
delete from foo where id in (SELECT id
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id);

select * from foo  order by 1,2,3;



replace into foo
with cte as
(
SELECT id, mgrid, name
FROM tree
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id)
SELECT id, mgrid, name
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;

select * from foo  order by 1,2,3;

with cte as
(
    select * from tree
)
delete from foo where id =some(SELECT id
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id);
select * from foo  order by 1,2,3;


replace into foo
with cte as
(
SELECT id, mgrid, name
FROM tree
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id)
SELECT id, mgrid, name
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;

select * from foo  order by 1,2,3;

with cte as
(
select * from tree
)
delete from foo where id >any(SELECT id
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id);
select * from foo  order by 1,2,3;


replace into foo
with cte as
(
SELECT id, mgrid, name
FROM tree
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id)
SELECT id, mgrid, name
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;

select * from foo  order by 1,2,3;

with cte as
(
select * from tree
)
delete from foo where id <=all(SELECT id
FROM cte
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id);
select * from foo  order by 1,2,3;

drop table if exists foo,tree;
