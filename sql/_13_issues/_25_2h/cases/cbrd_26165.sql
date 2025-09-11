/**
 *  This test case verifies CBRD-26165 : SQL statement execution fails after COMMIT is executed inside a loop
 *  
 *  Coverage:
 *  Different Scenario
1 - COMMIT executed inside a loop
2 - COMMIT executed via EXECUTE IMMEDIATE inside a loop
3 - COMMIT executed within a recursive call
 **/

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

DROP PROCEDURE test_pl;
DROP FUNCTION foo;
DROP TABLE test_tbl;
DROP TABLE ttt;
