-- NO NULLS
DROP TABLE IF EXISTS test_tbl;
CREATE TABLE test_tbl(groupid int,itemno int);
INSERT INTO test_tbl VALUES(1,1);
INSERT INTO test_tbl VALUES(1,2);
INSERT INTO test_tbl VALUES(1,3);
INSERT INTO test_tbl VALUES(1,4);
INSERT INTO test_tbl VALUES(1,5);
INSERT INTO test_tbl VALUES(2,6);
INSERT INTO test_tbl VALUES(2,7);

select groupid, itemno, first_value(itemno) over (partition by groupid) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) over (partition by groupid order by itemno nulls first) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) over (partition by groupid order by itemno nulls last) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid order by itemno nulls first) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid order by itemno nulls last) x from test_tbl order by 1, 2, 3;


-- LEADING AND TRAILING NULLS
DROP TABLE IF EXISTS test_tbl;
CREATE TABLE test_tbl(groupid int,itemno int);
INSERT INTO test_tbl VALUES(1,NULL);
INSERT INTO test_tbl VALUES(1,1);
INSERT INTO test_tbl VALUES(1,2);
INSERT INTO test_tbl VALUES(1,3);
INSERT INTO test_tbl VALUES(1,4);
INSERT INTO test_tbl VALUES(1,5);
INSERT INTO test_tbl VALUES(1,NULL);
INSERT INTO test_tbl VALUES(2,NULL);
INSERT INTO test_tbl VALUES(2,6);
INSERT INTO test_tbl VALUES(2,7);
INSERT INTO test_tbl VALUES(2,NULL);

select groupid, itemno, first_value(itemno) over (partition by groupid) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) over (partition by groupid order by itemno nulls first) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) over (partition by groupid order by itemno nulls last) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid order by itemno nulls first) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid order by itemno nulls last) x from test_tbl order by 1, 2, 3;


-- MIXED NULLS
DROP TABLE IF EXISTS test_tbl;
CREATE TABLE test_tbl(groupid int,itemno int);
INSERT INTO test_tbl VALUES(1,NULL);
INSERT INTO test_tbl VALUES(1,1);
INSERT INTO test_tbl VALUES(1,NULL);
INSERT INTO test_tbl VALUES(1,2);
INSERT INTO test_tbl VALUES(1,3);
INSERT INTO test_tbl VALUES(1,NULL);
INSERT INTO test_tbl VALUES(1,4);
INSERT INTO test_tbl VALUES(1,5);
INSERT INTO test_tbl VALUES(1,NULL);
INSERT INTO test_tbl VALUES(2,NULL);
INSERT INTO test_tbl VALUES(2,6);
INSERT INTO test_tbl VALUES(1,NULL);
INSERT INTO test_tbl VALUES(2,7);
INSERT INTO test_tbl VALUES(2,NULL);

select groupid, itemno, first_value(itemno) over (partition by groupid) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) over (partition by groupid order by itemno nulls first) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) over (partition by groupid order by itemno nulls last) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid order by itemno nulls first) x from test_tbl order by 1, 2, 3;
select groupid, itemno, first_value(itemno) ignore nulls over (partition by groupid order by itemno nulls last) x from test_tbl order by 1, 2, 3;


-- DONE
DROP TABLE IF EXISTS test_tbl;
