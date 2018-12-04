drop table if exists test_tbl,foo1,foo2;
CREATE TABLE test_tbl(groupid int,itemno int);
INSERT INTO test_tbl VALUES(1,null);
INSERT INTO test_tbl VALUES(1,1);
INSERT INTO test_tbl VALUES(1,null);
INSERT INTO test_tbl VALUES(1,2);
INSERT INTO test_tbl VALUES(1,5);
INSERT INTO test_tbl VALUES(2,null);
INSERT INTO test_tbl VALUES(2,7);
create table foo1 as
with cte as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) select * from cte;

create table foo2 as
with cte as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) select * from cte;

select count(*) from foo1;
select count(*) from foo2;


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
) select y.* from foo1,
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte1
 ) as x( groupid, itemno,ret_val),(SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret
FROM cte2 ) as y( groupid, itemno,ret_val)
where foo1.groupid=x.groupid and x.groupid=y.groupid;
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
) select y.ret_val from foo1,
(
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM cte1
 ) as x( groupid, itemno,ret_val),(SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret
FROM cte2 ) as y( groupid, itemno,ret_val)
where foo1.groupid=x.groupid and x.groupid=y.groupid
);
select count(*) from foo1;

drop table if exists test_tbl,foo1,foo2;
