/**
 * This test case verifies CBRD-26155: PL/CSQL Static SQL should raise compile-time error when bind parameter (?) is used
 *
 * Issue: Currently bind parameters in static SQL pass semantic checks but fail at runtime
 * Expected: Compile-time error should be raised during procedure creation
 */

--+ server-message on

-- Setup: Create test table
DROP TABLE IF EXISTS athlete;
CREATE TABLE IF NOT EXISTS athlete (
    code INT PRIMARY KEY,
    name VARCHAR(40)
);

INSERT INTO athlete VALUES (1, 'John Doe');
INSERT INTO athlete VALUES (2, 'Jane Smith');
INSERT INTO athlete VALUES (3, 'Bob Johnson');
INSERT INTO athlete VALUES (4, '?');

evaluate 'Case 1. Single bind parameter in WHERE clause';
CREATE OR REPLACE PROCEDURE proc_bind_where AS
    n VARCHAR(40);
BEGIN
    SELECT name INTO n FROM athlete WHERE code = ?;
END;

CALL proc_bind_where();

evaluate 'Case 2. Multiple bind parameters';
CREATE OR REPLACE PROCEDURE proc_bind_multiple AS
    n VARCHAR(40);
    c INT;
BEGIN
    SELECT name, code INTO n, c FROM athlete WHERE code = ? AND name = ?;
END;

CALL proc_bind_multiple();

evaluate 'Case 3. Bind parameter in INSERT statement';
CREATE OR REPLACE PROCEDURE proc_bind_insert AS
BEGIN
    INSERT INTO athlete VALUES (?, 'Test Name');
END;

CALL proc_bind_insert();

evaluate 'Case 4. Bind parameter in UPDATE statement';
CREATE OR REPLACE PROCEDURE proc_bind_update AS
BEGIN
    UPDATE athlete SET name = ? WHERE code = 1;
END;

CALL proc_bind_update();

evaluate 'Case 5. Bind parameter in DELETE statement';
CREATE OR REPLACE PROCEDURE proc_bind_delete AS
BEGIN
    DELETE FROM athlete WHERE code = ?;
END;

CALL proc_bind_delete();

evaluate 'Case 6. Bind parameter in SELECT list';
CREATE OR REPLACE PROCEDURE proc_bind_select_list AS
    result VARCHAR(40);
BEGIN
    SELECT ? INTO result FROM athlete WHERE code = 1;
END;

CALL proc_bind_select_list();

evaluate 'Case 7. Bind parameter in HAVING clause';
CREATE OR REPLACE PROCEDURE proc_bind_having AS
    cnt INT;
BEGIN
    SELECT COUNT(*) INTO cnt FROM athlete GROUP BY name HAVING COUNT(*) > ?;
END;

CALL proc_bind_having();

evaluate 'Case 8. Bind parameter in subquery';
CREATE OR REPLACE PROCEDURE proc_bind_subquery AS
    n VARCHAR(40);
BEGIN
    SELECT name INTO n FROM athlete WHERE code IN (SELECT code FROM athlete WHERE name = ?);
END;

CALL proc_bind_subquery();

evaluate 'Case 9. Bind parameter in function call';
CREATE OR REPLACE PROCEDURE proc_bind_function AS
    n VARCHAR(40);
BEGIN
    SELECT name INTO n FROM athlete WHERE code = COALESCE(?, 1);
END;

CALL proc_bind_function();

evaluate 'Case 10. ? inside quotes (valid case)';
CREATE OR REPLACE PROCEDURE proc_where_value AS
    n VARCHAR(40);
BEGIN
    SELECT name INTO n FROM athlete WHERE name = '?';
    DBMS_OUTPUT.put_line('Name: ' || n);
END;

CALL proc_where_value();

evaluate 'Case 11. Valid procedure without bind parameters';
CREATE OR REPLACE PROCEDURE proc_valid AS
    n VARCHAR(40);
BEGIN
    SELECT name INTO n FROM athlete WHERE code = 1;
    DBMS_OUTPUT.put_line('Name: ' || n);
END;

CALL proc_valid();

-- Cleanup
-- Note: DROP for procedures with ? will fail with error -894 (expected behavior)
DROP PROCEDURE proc_bind_where;
DROP PROCEDURE proc_bind_multiple;
DROP PROCEDURE proc_bind_insert;
DROP PROCEDURE proc_bind_update;
DROP PROCEDURE proc_bind_delete;
DROP PROCEDURE proc_bind_select_list;
DROP PROCEDURE proc_bind_having;
DROP PROCEDURE proc_bind_subquery;
DROP PROCEDURE proc_bind_function;
DROP PROCEDURE proc_where_value;
DROP PROCEDURE proc_valid;

DROP TABLE IF EXISTS athlete;

--+ server-message off
