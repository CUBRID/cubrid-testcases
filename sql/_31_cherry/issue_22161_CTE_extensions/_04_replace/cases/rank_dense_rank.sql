drop table if exists test_tbl,foo3,foo4;
CREATE TABLE test_tbl(VAL INT);
INSERT INTO test_tbl VALUES (100), (200), (200), (300), (400);

--create
create table foo3 as
with cte as
(
 SELECT RANK() OVER (ORDER BY val) AS rk FROM test_tbl
) select * from cte;

create table foo4 as
with cte as
(
 SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM test_tbl
) select * from cte;

describe foo3;
describe foo4;

--insert
insert into foo3
with cte as
(
 SELECT RANK() OVER (ORDER BY val) AS rk FROM test_tbl
) select * from cte;


insert into foo3
with cte as
(
 select * from test_tbl
) SELECT RANK() OVER (ORDER BY val) AS rk FROM cte;

insert into foo4
with cte as
(
 SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM test_tbl
) select * from cte;


insert into foo4
with cte as
(
  select * from test_tbl
) SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM cte;

select cast(rk as numeric(4,2)) from foo3 order by 1;
select cast(dense_rnk as numeric(4,2)) from foo4 order by 1;

--update
with cte as
(
 SELECT RANK() OVER (ORDER BY val) AS rk FROM test_tbl
) update foo3 set rk=-3 where rk in (
with cte as
(
 select * from test_tbl
) SELECT RANK() OVER (ORDER BY val) AS rk FROM cte);


with cte as
(
 SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM test_tbl
) update foo4 set dense_rnk=-4 where dense_rnk in (
with cte as
(
  select * from test_tbl
) SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM cte);

select *  from foo3 order by 1;
select *  from foo4 order by 1;


--replace
replace into foo3
with cte as
(
 SELECT RANK() OVER (ORDER BY val) AS rk FROM test_tbl
) select * from cte;


replace into foo3
with cte as
(
 select * from test_tbl
) SELECT RANK() OVER (ORDER BY val) AS rk FROM cte;
insert into foo4
with cte as
(
 SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM test_tbl
) select * from cte;


replace into foo4
with cte as
(
  select * from test_tbl
) SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM cte;

select cast(rk as numeric(4,2)) from foo3 order by 1;
select cast(dense_rnk as numeric(4,2)) from foo4 order by 1;

--delete
with cte as
(
 SELECT RANK() OVER (ORDER BY val) AS rk FROM test_tbl
) delete from  foo3  where rk in (
with cte as
(
 select * from test_tbl
) SELECT RANK() OVER (ORDER BY val) AS rk FROM cte);

with cte as
(
 SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM test_tbl
) delete from foo4  where dense_rnk in (
with cte as
(
  select * from test_tbl
) SELECT DENSE_RANK() OVER (ORDER BY val) AS dense_rnk FROM cte);

select *  from foo3 order by 1;
select *  from foo4 order by 1;

drop table if exists foo3,foo4,test_tbl;
