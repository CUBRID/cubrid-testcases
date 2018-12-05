drop table if exists test_tbl,foo1,foo2;
CREATE TABLE test_tbl(groupid int,itemno int);
INSERT INTO test_tbl VALUES(1,null);
INSERT INTO test_tbl VALUES(1,null);
INSERT INTO test_tbl VALUES(1,1);
INSERT INTO test_tbl VALUES(1,null);
INSERT INTO test_tbl VALUES(1,2);
INSERT INTO test_tbl VALUES(1,3);
INSERT INTO test_tbl VALUES(1,4);
INSERT INTO test_tbl VALUES(1,5);
INSERT INTO test_tbl VALUES(2,null);
INSERT INTO test_tbl VALUES(2,null);
INSERT INTO test_tbl VALUES(2,null);
INSERT INTO test_tbl VALUES(2,6);
INSERT INTO test_tbl VALUES(2,7);
create table foo1 as
with cte as
(
  select * from test_tbl
) SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte;

create table foo2 as
with cte as
(
  select * from test_tbl
)
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte;

select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;

--delete
with cte1 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) ,
cte2 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) delete foo2 from  foo2 inner join
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte1
 ) as x( groupid, itemno,ret_val) on foo2.groupid=x.groupid  inner join (SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte2 ) as y( groupid, itemno,ret_val) on x.groupid=y.groupid and foo2.ret_val=y.ret_val;
select count(*) from foo2;

--update
with cte1 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) ,
cte2 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) update foo1 inner join
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte1
 ) as x( groupid, itemno,ret_val) on foo1.groupid=x.groupid inner join (SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret
FROM cte2 ) as y( groupid, itemno,ret_val) on x.groupid=y.groupid
set foo1.ret_val=1;
select count(*) from foo1;

--insert 
insert into foo1
with cte1 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) ,
cte2 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) select y.* from foo1 inner join 
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte1
 ) as x( groupid, itemno,ret_val) on foo1.groupid=x.groupid inner join (SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret
FROM cte2 ) as y( groupid, itemno,ret_val) on x.groupid=y.groupid;
select count(*) from foo1;

--replace
replace into foo1
set ret_val=(
with cte1 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) ,
cte2 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) select y.ret_val from 
  foo1,
  (
   SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val FROM cte1
  ) as x( groupid, itemno,ret_val),
  ( 
    SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret FROM cte2 
  ) as y( groupid, itemno,ret_val) 
  where foo1.groupid=x.groupid and x.groupid=y.groupid limit 1
);

select count(*) from foo1;

drop table if exists test_tbl,foo1,foo2;
