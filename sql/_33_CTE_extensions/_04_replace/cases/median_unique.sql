drop table if exists t;
create table t(i int,j varchar(10),k char(10),l int);
insert into t values(1,2,3,1);
insert into t values(2,3,1,2);
insert into t values(3,1,2,3);
insert into t 
with mycte as
(
 select median(i),median(j),median(k),4 from t
) select * from mycte;
select * from t order by l;

with mycte(a,b) as
(
 select i,count(i) from t group by i
) delete t from t,mycte where t.i=mycte.a and mycte.b>1 and t.l=4;
select * from t order by l;

alter table t change i i int unique;
replace into t with mycte as
(
 select median(i),median(j),median(k),4 from t
) select * from mycte;
select * from t order by l;
drop table if exists t;

drop if exists tbl,foo1,foo2,v1,v2;
CREATE TABLE tbl (col1 int, col2 double);
INSERT INTO tbl VALUES(1,2), (1,1.5), (1,1.7), (1,1.8), (2,3), (2,4), (3,5);

create view v1 as
SELECT col1, MEDIAN(col2) as mdn
 FROM tbl GROUP BY col1;

create view v2 as
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM tbl;

describe v1;
describe v2;

create table foo1(i int,j double);
create table foo2(i int,j double);

--insert
insert into foo1
with cte as
(
 SELECT col1, MEDIAN(col2) as mdn
 FROM tbl GROUP BY col1
) select * from cte;

insert into foo1
with cte as
(
 select * from tbl
)
 SELECT col1, MEDIAN(col2) as mdn
 FROM cte GROUP BY col1;

insert into foo2
with cte as
(
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) select * from cte;

insert into foo2
with cte as
(
   select * from tbl
)
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM cte;

select * from foo1 order by 1,2;
select * from foo2 order by 1,2;


--delete
with cte as
(
 SELECT col1, MEDIAN(col2) as mdn
 FROM tbl GROUP BY col1
) delete from foo1 where exists (
with cte as
(
 select * from tbl
)
 SELECT col1,MEDIAN(col2) as mdn
 FROM cte GROUP BY col1);

--CBRD-22597
--with cte as
--(
--SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
--FROM tbl
--) delete from foo2 where exists (
--with cte as
--(
--   select * from tbl
--)
--SELECT col1,MEDIAN(col2) OVER (PARTITION BY col1) as mdn
--FROM cte);

select * from foo1 order by 1,2;
select * from foo2 order by 1,2;


--replace
replace into foo1
with cte as
(
 SELECT col1, MEDIAN(col2) as mdn
 FROM tbl GROUP BY col1
) select * from cte;

replace into foo1
with cte as
(
 select * from tbl
)
 SELECT col1, MEDIAN(col2) as mdn
 FROM cte GROUP BY col1;

replace into foo2
with cte as
(
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) select * from cte;

replace into foo2
with cte as
(
   select * from tbl
)
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM cte;

select * from foo1 order by 1,2;
select * from foo2 order by 1,2;

--update
with cte as
(
 SELECT col1, MEDIAN(col2) as mdn
 FROM tbl GROUP BY col1
) update foo1 set i=i+100 where exists(
with cte as
(
 select * from tbl
)
 SELECT col1, MEDIAN(col2) as mdn
 FROM cte GROUP BY col1 );

--CBRD-22597
--with cte as
--(
--SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
--FROM tbl
--) update foo2 set i=i+100 where exists(
--with cte as
--(
--   select * from tbl
--)
--SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
--FROM cte);

select * from foo1 order by 1,2;
select * from foo2 order by 1,2;

drop table if exists foo1,foo2,tbl;
