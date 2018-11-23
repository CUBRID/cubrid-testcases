drop table if exists test_tbl,foo1,foo2,foo3,foo4;
CREATE TABLE test_tbl(VAL INT);
INSERT INTO test_tbl VALUES (100), (200), (200), (300), (400);

--create
create table foo1 as
with cte as
(
 SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM test_tbl
) select * from cte;


create table foo2 as
with cte as
(
 SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM test_tbl
) select * from cte;

create table foo3 as
with cte as
(
 SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM test_tbl
) select * from cte;

create table foo4 as
with cte as
(
 SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM test_tbl
) select * from cte;

describe foo1;
describe foo2;
describe foo3;
describe foo4;

--insert
insert into foo1
with cte as
(
 SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM test_tbl
) select * from cte;

insert into foo1
with cte as
(
   select * from test_tbl 
) SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM cte;

insert into foo2
with cte as
(
 SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM test_tbl
) select * from cte;

insert into foo2
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM cte;

insert into foo3
with cte as
(
 SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM test_tbl
) select * from cte;


insert into foo3
with cte as
(
 select * from test_tbl
) SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM cte;

insert into foo4
with cte as
(
 SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM test_tbl
) select * from cte;


insert into foo4
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM cte;

select cast(cume as numeric(4,2)) from foo1;
select cast(pct_rnk as numeric(4,2)) from foo2;
select cast(cume as numeric(4,2)) from foo3;
select cast(pct_rnk as numeric(4,2)) from foo4;

--update
with cte as
(
 SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM test_tbl
) update foo1 set cume=-1 where cume in (
with cte as
(
   select * from test_tbl
) SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM cte );

with cte as
(
 SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM test_tbl
) update foo2 set pct_rnk=-2 where pct_rnk in(
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM cte );

with cte as
(
 SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM test_tbl
) update foo3 set cume=-3 where cume in (
with cte as
(
 select * from test_tbl
) SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM cte);


with cte as
(
 SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM test_tbl
) update foo4 set pct_rnk=-4 where pct_rnk in (
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM cte);

select *  from foo1;
select *  from foo2;
select *  from foo3;
select *  from foo4;


--replace
replace into foo1
with cte as
(
 SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM test_tbl
) select * from cte;

insert into foo1
with cte as
(
   select * from test_tbl 
) SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM cte;

replace into foo2
with cte as
(
 SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM test_tbl
) select * from cte;

replace into foo2
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM cte;

replace into foo3
with cte as
(
 SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM test_tbl
) select * from cte;


replace into foo3
with cte as
(
 select * from test_tbl
) SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM cte;
insert into foo4
with cte as
(
 SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM test_tbl
) select * from cte;


replace into foo4
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM cte;

select cast(cume as numeric(4,2)) from foo1;
select cast(pct_rnk as numeric(4,2)) from foo2;
select cast(cume as numeric(4,2)) from foo3;
select cast(pct_rnk as numeric(4,2)) from foo4;

--delete
with cte as
(
 SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM test_tbl
) delete from  foo1 where cume in (
with cte as
(
   select * from test_tbl
) SELECT CUME_DIST(200) WITHIN GROUP (ORDER BY val) AS cume FROM cte );

with cte as
(
 SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM test_tbl
) delete from foo2 where pct_rnk in(
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK(200) WITHIN GROUP (ORDER BY val) AS pct_rnk FROM cte );

with cte as
(
 SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM test_tbl
) delete from  foo3  where cume in (
with cte as
(
 select * from test_tbl
) SELECT CUME_DIST() OVER (ORDER BY val) AS cume FROM cte);

with cte as
(
 SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM test_tbl
) delete from foo4  where pct_rnk in (
with cte as
(
  select * from test_tbl
) SELECT PERCENT_RANK() OVER (ORDER BY val) AS pct_rnk FROM cte);

select *  from foo1;
select *  from foo2;
select *  from foo3;
select *  from foo4;
