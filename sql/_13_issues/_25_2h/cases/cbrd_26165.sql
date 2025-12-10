/**
 *  This test case verifies CBRD-26165 : SQL statement execution fails after COMMIT is executed inside a loop
 *  
 *  Coverage:
 *  Different Scenario
 *  1 - COMMIT executed inside a loop
 *  2 - COMMIT executed via EXECUTE IMMEDIATE inside a loop
 *  3 - COMMIT executed within a recursive call
 *  4 - COMMIT executed in a nested procedure call
 */

evaluate '1 - COMMIT executed inside a loop';
DROP TABLE IF EXISTS test_tbl;
CREATE TABLE test_tbl(id INT);
CREATE OR REPLACE PROCEDURE test_pl()
AS
    i INT DEFAULT 1;
BEGIN
    WHILE i <= 5 LOOP
        INSERT INTO test_tbl(id) VALUES(i);
        i := i + 1;

        IF i = 3 THEN
            COMMIT; 
        END IF;
    END LOOP;

    INSERT INTO test_tbl(id) VALUES(999); 
    COMMIT;
END;

CALL test_pl();
SELECT * FROM test_tbl ORDER BY id;

evaluate '2 - COMMIT executed via EXECUTE IMMEDIATE inside a loop';
DROP TABLE IF EXISTS test_tbl;
CREATE TABLE test_tbl(id INT);

CREATE OR REPLACE PROCEDURE test_pl()
AS
    i INT DEFAULT 1;
BEGIN
    WHILE i <= 5 LOOP
        INSERT INTO test_tbl(id) VALUES(i);
        i := i + 1;

        IF i = 3 THEN
            EXECUTE IMMEDIATE 'COMMIT';  
        END IF;
    END LOOP;
   
    INSERT INTO test_tbl(id) VALUES(999);
    COMMIT;
END;

CALL test_pl();
SELECT * FROM test_tbl ORDER BY id;

evaluate '3 - COMMIT executed within a recursive call';
DROP TABLE IF EXISTS ttt;
CREATE TABLE ttt(m INT);

CREATE OR REPLACE FUNCTION foo(n INT) RETURN INT AS
BEGIN
    RETURN NULL;
END;

CREATE OR REPLACE FUNCTION foo(n INT) RETURN INT AS
    r INT;
BEGIN
    IF n <= 0 THEN
        COMMIT;
        RETURN 0;
    END IF;

    FOR i IN 1..n LOOP
        INSERT INTO ttt VALUES (n);
        SELECT foo(n-1) INTO r;
        -- (*)
    END LOOP;

    RETURN n;
END;

SELECT foo(3);
SELECT m, COUNT(*) FROM ttt GROUP BY m ORDER BY m;
SELECT COUNT(*) FROM ttt;

evaluate '4 - COMMIT executed in a nested procedure call';
DROP TABLE IF EXISTS test_tbl;
CREATE TABLE test_tbl(id INT);

-- Inner procedure
CREATE OR REPLACE PROCEDURE inner_proc(p INT)
AS
BEGIN
    INSERT INTO test_tbl VALUES(p);
    COMMIT;
END;

-- Outer procedure
CREATE OR REPLACE PROCEDURE outer_proc()
AS
    i INT DEFAULT 1;
BEGIN
    WHILE i <= 5 LOOP
        inner_proc(i);
        i := i + 1;
    END LOOP;

    INSERT INTO test_tbl VALUES(999);
    COMMIT;
END;

CALL outer_proc();
SELECT * FROM test_tbl ORDER BY id;


DROP PROCEDURE test_pl;
DROP PROCEDURE inner_proc;
DROP PROCEDURE outer_proc;
DROP FUNCTION foo;
DROP TABLE test_tbl;
DROP TABLE ttt;
