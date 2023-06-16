-- Test commit and rollback in pl/csql


-- 1) Test COMMIT

--+ server-output on
autocommit off;

SET SYSTEM PARAMETERS 'pl_transaction_control=yes';

DROP TABLE IF EXISTS test_tcl_tbl;
CREATE TABLE test_tcl_tbl (code INT, name STRING);

create or replace procedure test_tcl_commit() as
    i int;
    n varchar;
begin
    INSERT INTO test_tcl_tbl VALUES (1,'aaa');
    INSERT INTO test_tcl_tbl VALUES (2,'bbb');
    INSERT INTO test_tcl_tbl VALUES (3,'ccc');
    INSERT INTO test_tcl_tbl VALUES (4,'ddd');
    COMMIT;

    for r in (SELECT code, name FROM test_tcl_tbl WHERE code > 2) loop
        i := r.code;
        n := r.name;
        DBMS_OUTPUT.PUT_LINE(i);
        DBMS_OUTPUT.PUT_LINE('code = ' || i || ' name = ' || n);
    end loop;
end;

CALL test_tcl_commit ();
ROLLBACK;

SELECT * FROM test_tcl_tbl; -- committed rows should be displayed
ROLLBACK;

-- 2) Test Rollback

DROP TABLE IF EXISTS test_tcl_tbl2;
CREATE TABLE test_tcl_tbl2 (code INT, name STRING);

create or replace procedure test_tcl_rollback () as
    i int;
    n varchar;
begin
    INSERT INTO test_tcl_tbl2 VALUES (1,'aaa');
    INSERT INTO test_tcl_tbl2 VALUES (2,'bbb');
    INSERT INTO test_tcl_tbl2 VALUES (3,'ccc');
    INSERT INTO test_tcl_tbl2 VALUES (4,'ddd');
    COMMIT;

    INSERT INTO test_tcl_tbl2 VALUES (6,'daf');
    INSERT INTO test_tcl_tbl2 VALUES (7,'qwe');
    ROLLBACK;

    for r in (SELECT code, name FROM test_tcl_tbl2 WHERE code > 2) loop
        i := r.code;
        n := r.name;
        DBMS_OUTPUT.PUT_LINE('code = ' || i || ', name = ' || n);
    end loop;
end;

CALL test_tcl_rollback ();
COMMIT;
SELECT * FROM test_tcl_tbl2;

autocommit on;