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
SELECT groupid, itemno, FIRST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) select * from cte;

create table foo2 as
with cte as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) select * from cte;

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
) delete from foo1,foo2 using foo1,foo2,cte1,cte2 where foo1.groupid=cte1.groupid
and foo1.ret_val=cte1.ret_val
and foo2.groupid=cte2.groupid
and foo2.ret_val=cte2.ret_val
and foo1.groupid=foo2.groupid;

select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;

insert into foo1
with cte as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) select * from cte;
select * from foo1 order by 1,2,3;

with cte1 as
(
    select * from foo1
) ,
cte2 as
(
SELECT groupid, itemno, FIRST_VALUE(itemno) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
FROM test_tbl
) delete from foo1,foo2 using foo1,foo2,cte1,cte2 where foo1.groupid=cte1.groupid
and foo1.ret_val=cte1.ret_val
and foo2.groupid=cte2.groupid
and foo2.ret_val=cte2.ret_val
and foo1.groupid=foo2.groupid;
select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;

with cte1 as
(
    select * from foo1
) delete from foo1 where exists (select foo1.* from cte1,foo1);

select * from foo1 order by 1,2,3;
select * from foo2 order by 1,2,3;

drop table if exists test_tbl,foo1,foo2;
