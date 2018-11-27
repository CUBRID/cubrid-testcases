drop if exists tbl,foo2;
CREATE TABLE tbl (col1 int, col2 double);
INSERT INTO tbl VALUES(1,2), (1,1.5), (1,1.7), (1,1.8), (2,3), (2,4), (3,5);
create table foo2(i int,j double);

--insert
insert into foo2
with cte as
(
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) select * from cte;

select * from foo2;

--delete
with cte as
(
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) delete from foo2 where exists (
with cte as
(
   select * from tbl
)
SELECT col1,MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM cte);

select * from foo2;

drop table if exists tbl,foo2;
CREATE TABLE tbl (col1 int, col2 double);
INSERT INTO tbl VALUES(1,2), (1,1.5), (1,1.7), (1,1.8), (2,3), (2,4), (3,5);
create table foo2(i int,j double);

insert into foo2
with cte as
(
SELECT col1, avg(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) select * from cte;

select * from foo2;

with cte as
(
SELECT col1, avg(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) delete from foo2 where exists (
with cte as
(
 select * from tbl
)SELECT col1,avg(col2) OVER (PARTITION BY col1) as mdn FROM cte
);

select * from foo2;

insert into foo2
with cte as
(
SELECT col1, avg(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) select * from cte;

select * from foo2;
with cte as
(
SELECT col1, avg(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) delete from foo2 where exists (
SELECT col1,avg(col2) OVER (PARTITION BY col1) as mdn
FROM tbl);

select * from foo2;
