-- NO NULLS
DROP TABLE IF EXISTS test_tbl;
CREATE TABLE test_tbl(groupid int,itemno int);
INSERT INTO test_tbl VALUES(1,    1);
INSERT INTO test_tbl VALUES(1,    NULL);
INSERT INTO test_tbl VALUES(1,    3);
INSERT INTO test_tbl VALUES(NULL, 4);
INSERT INTO test_tbl VALUES(NULL, 5);
INSERT INTO test_tbl VALUES(2,    NULL);
INSERT INTO test_tbl VALUES(NULL, 7);
INSERT INTO test_tbl VALUES(2,    8);
INSERT INTO test_tbl VALUES(3,    NULL);
INSERT INTO test_tbl VALUES(4,    10);

select groupid, itemno, first_value(itemno) over (order by groupid nulls first, itemno nulls first) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, first_value(itemno) over (order by groupid nulls first, itemno nulls last) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, first_value(itemno) ignore nulls over (order by groupid nulls first, itemno nulls first) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, first_value(itemno) ignore nulls over (order by groupid nulls first, itemno nulls last) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;

select groupid, itemno, last_value(itemno) over (order by groupid nulls first, itemno nulls first) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, last_value(itemno) over (order by groupid nulls first, itemno nulls last) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, last_value(itemno) ignore nulls over (order by groupid nulls first, itemno nulls first) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, last_value(itemno) ignore nulls over (order by groupid nulls first, itemno nulls last) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;

select groupid, itemno, nth_value(itemno, 5) over (order by groupid nulls first, itemno nulls first) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, nth_value(itemno, 5) over (order by groupid nulls first, itemno nulls last) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, nth_value(itemno, 5) ignore nulls over (order by groupid nulls first, itemno nulls first) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;
select groupid, itemno, nth_value(itemno, 5) ignore nulls over (order by groupid nulls first, itemno nulls last) x from test_tbl order by 1 nulls first, 2 nulls first, 3 nulls first;

-- DONE
DROP TABLE IF EXISTS test_tbl;
