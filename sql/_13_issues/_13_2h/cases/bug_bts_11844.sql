--+ holdcas on;

drop table if exists test_tbl;

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

SELECT groupid, itemno, NTH_VALUE(itemno, 2) IGNORE NULLS OVER(PARTITION BY groupid ORDER BY itemno NULLS FIRST) AS ret_val 
FROM test_tbl;

drop table if exists test_tbl;

--+ holdcas off;
commit;
