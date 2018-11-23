drop table if exists test_tbl,foo1;
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

--create and delete
create table foo1 as
with cte as
(
 SELECT groupid, itemno, LAST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
 FROM test_tbl
) select * from cte;

select * from foo1 order by 1,2,3;


with cte as
(
 SELECT groupid, itemno, LAST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
 FROM test_tbl
) delete from foo1 using foo1,cte;

select * from foo1 order by 1,2,3;

--insert and replace
insert into foo1
with cte as
(
 SELECT groupid, itemno, LAST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
 FROM test_tbl
) select * from cte;

select * from foo1 order by 1,2,3;

alter table foo1 change column itemno  itemno int unique;

replace into foo1
with cte as
(
 SELECT groupid, itemno, LAST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_val
 FROM test_tbl
) select * from cte;

select * from foo1 order by 1,2,3;

--update
with cte as
(
 SELECT groupid, itemno,ret_val, LAST_VALUE(itemno) OVER(PARTITION BY groupid ORDER BY itemno) AS ret_vala
 FROM foo1
) update foo1 inner join cte on foo1.groupid=cte.groupid
set foo1.ret_val=(select median(ret_vala) from cte)
where foo1.ret_val is null;

select * from foo1 order by 1,2,3;

drop table if exists test_tbl,foo1;
