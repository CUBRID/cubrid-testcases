/**
 * This test case verifies CBRD-26708: Provide SQL data access information during PL/CSQL SP compilation
 *
 * During compilation of a PL/CSQL stored procedure/function, the SQL data access
 * characteristic is automatically determined by static analysis of the body and
 * stored in the catalog. It is exposed via db_stored_procedure.sql_data_access and
 * information_schema.routines.sql_data_access with one of:
 *   NO SQL / CONTAINS SQL / READS SQL DATA / MODIFIES SQL DATA
 *
 * Coverage:
 * 1 - NO SQL: no SQL statement at all (pure computation / DBMS_OUTPUT / empty body),
 *     dynamic SQL (EXECUTE IMMEDIATE, incl. DDL), nested SP call
 * 2 - CONTAINS SQL: SQL that does not touch table data - expression-only SELECT,
 *     function SELECT without FROM, control statement (COMMIT / ROLLBACK),
 *     set-derived table TABLE({...}), and a view built on such a virtual table
 * 3 - READS SQL DATA: SELECT INTO / cursor / OPEN FOR / FOR-IN-LOOP over a table,
 *     derived table (subquery) over a real table, view over a base table,
 *     constant select-list with a real-table FROM, dual, and mixed CONTAINS+READS
 * 4 - MODIFIES SQL DATA: INSERT / UPDATE / DELETE / MERGE / REPLACE / TRUNCATE /
 *     INSERT ... SELECT, and mixed READS + MODIFIES
 * 5 - The determination follows the strongest access level found in the body
 * 6 - Verify the value is also exposed through information_schema.routines
 */

--+ server-message on

DROP TABLE IF EXISTS tbl1;
CREATE TABLE tbl1 (a INT);
INSERT INTO tbl1 VALUES (1), (2), (3);

CREATE OR REPLACE VIEW v_tbl1 AS SELECT a FROM tbl1;
CREATE OR REPLACE VIEW v_set AS SELECT * FROM TABLE({1, 2, 3}) t(i);

evaluate 'Case 1: NO SQL - procedure with only DBMS_OUTPUT, function with arithmetic';
CREATE OR REPLACE PROCEDURE p_nosql AS
BEGIN
  DBMS_OUTPUT.put_line('no sql here');
END;

CREATE OR REPLACE FUNCTION f_calc(x INT) RETURN INT AS
BEGIN
  RETURN x * 2;
END;

evaluate 'Case 2: NO SQL - empty body (no statement at all)';
CREATE OR REPLACE PROCEDURE p_empty AS
BEGIN
  NULL;
END;

evaluate 'Case 3: CONTAINS SQL - SELECT of an expression without table reference';
CREATE OR REPLACE FUNCTION f_contains RETURN INT AS
  n INT;
BEGIN
  SELECT 1 + 1 INTO n;
  RETURN n;
END;

evaluate 'Case 4: CONTAINS SQL - SELECT of a function without FROM (no table data)';
CREATE OR REPLACE FUNCTION f_func_nofrom RETURN VARCHAR AS
  v VARCHAR(256);
BEGIN
  SELECT database() INTO v;
  RETURN v;
END;

evaluate 'Case 5: CONTAINS SQL - control statement COMMIT';
CREATE OR REPLACE PROCEDURE p_commit AS
BEGIN
  COMMIT;
END;

evaluate 'Case 6: CONTAINS SQL - control statement ROLLBACK';
CREATE OR REPLACE PROCEDURE p_rollback AS
BEGIN
  ROLLBACK;
END;

evaluate 'Case 7: CONTAINS SQL - set-derived table TABLE({...}) is not real table data';
CREATE OR REPLACE FUNCTION f_setderived RETURN INT AS
  n INT;
BEGIN
  SELECT count(*) INTO n FROM TABLE({1, 2, 3}) t(i);
  RETURN n;
END;

evaluate 'Case 8: CONTAINS SQL - view built on a set-derived (virtual) table';
CREATE OR REPLACE FUNCTION f_view_set RETURN INT AS
  n INT;
BEGIN
  SELECT count(*) INTO n FROM v_set;
  RETURN n;
END;

evaluate 'Case 9: READS SQL DATA - SELECT INTO from a table';
CREATE OR REPLACE FUNCTION f_reads RETURN INT AS
  n INT;
BEGIN
  SELECT count(*) INTO n FROM tbl1;
  RETURN n;
END;

evaluate 'Case 10: READS SQL DATA - constant select-list but FROM a real table';
CREATE OR REPLACE FUNCTION f_const_realtbl RETURN INT AS
  n INT;
BEGIN
  SELECT 1 INTO n FROM tbl1 LIMIT 1;
  RETURN n;
END;

evaluate 'Case 11: READS SQL DATA - SELECT from dual';
CREATE OR REPLACE FUNCTION f_dual RETURN INT AS
  n INT;
BEGIN
  SELECT 1 INTO n FROM dual;
  RETURN n;
END;

evaluate 'Case 12: READS SQL DATA - explicit cursor over a table SELECT';
CREATE OR REPLACE FUNCTION f_cursor RETURN INT AS
  CURSOR c IS SELECT a FROM tbl1;
  n INT := 0;
BEGIN
  OPEN c;
  CLOSE c;
  RETURN n;
END;

evaluate 'Case 13: READS SQL DATA - OPEN FOR (ref cursor) over a table SELECT';
CREATE OR REPLACE FUNCTION f_openfor RETURN INT AS
  c SYS_REFCURSOR;
  n INT := 0;
BEGIN
  OPEN c FOR SELECT a FROM tbl1;
  CLOSE c;
  RETURN n;
END;

evaluate 'Case 14: READS SQL DATA - FOR ... IN (SELECT) LOOP over a table';
CREATE OR REPLACE FUNCTION f_forloop RETURN INT AS
  n INT := 0;
BEGIN
  FOR r IN (SELECT a FROM tbl1) LOOP
    n := n + 1;
  END LOOP;
  RETURN n;
END;

evaluate 'Case 15: READS SQL DATA - SELECT from a derived table (subquery) over a real table';
CREATE OR REPLACE FUNCTION f_subquery RETURN INT AS
  n INT;
BEGIN
  SELECT count(*) INTO n FROM (SELECT a FROM tbl1) d;
  RETURN n;
END;

evaluate 'Case 16: READS SQL DATA - SELECT from a view over a base table';
CREATE OR REPLACE FUNCTION f_view RETURN INT AS
  n INT;
BEGIN
  SELECT count(*) INTO n FROM v_tbl1;
  RETURN n;
END;

evaluate 'Case 17: READS SQL DATA - strongest wins, CONTAINS + READS in one body -> READS';
CREATE OR REPLACE FUNCTION f_contains_reads RETURN INT AS
  a1 INT;
  a2 INT;
BEGIN
  SELECT 1 + 1 INTO a1;
  SELECT count(*) INTO a2 FROM tbl1;
  RETURN a1 + a2;
END;

evaluate 'Case 18: MODIFIES SQL DATA - INSERT';
CREATE OR REPLACE PROCEDURE p_insert AS
BEGIN
  INSERT INTO tbl1 VALUES (99);
END;

evaluate 'Case 19: MODIFIES SQL DATA - UPDATE';
CREATE OR REPLACE PROCEDURE p_update AS
BEGIN
  UPDATE tbl1 SET a = a + 1;
END;

evaluate 'Case 20: MODIFIES SQL DATA - DELETE';
CREATE OR REPLACE PROCEDURE p_delete AS
BEGIN
  DELETE FROM tbl1 WHERE a > 100;
END;

evaluate 'Case 21: MODIFIES SQL DATA - MERGE';
CREATE OR REPLACE PROCEDURE p_merge AS
BEGIN
  MERGE INTO tbl1 USING (SELECT 1 AS x) s ON (tbl1.a = s.x)
    WHEN NOT MATCHED THEN INSERT VALUES (s.x);
END;

evaluate 'Case 22: MODIFIES SQL DATA - REPLACE';
CREATE OR REPLACE PROCEDURE p_replace AS
BEGIN
  REPLACE INTO tbl1 VALUES (1);
END;

evaluate 'Case 23: MODIFIES SQL DATA - TRUNCATE';
CREATE OR REPLACE PROCEDURE p_truncate AS
BEGIN
  TRUNCATE TABLE tbl1;
END;

evaluate 'Case 24: MODIFIES SQL DATA - INSERT ... SELECT (read + write)';
CREATE OR REPLACE PROCEDURE p_insert_select AS
BEGIN
  INSERT INTO tbl1 SELECT a FROM tbl1 WHERE a < 0;
END;

evaluate 'Case 25: MODIFIES SQL DATA - strongest wins, READS + MODIFIES in one body -> MODIFIES';
CREATE OR REPLACE PROCEDURE p_mixed AS
  n INT;
BEGIN
  SELECT count(*) INTO n FROM tbl1;
  INSERT INTO tbl1 VALUES (n);
END;

evaluate 'Case 26: NO SQL - dynamic SQL string is not statically analyzed';
CREATE OR REPLACE PROCEDURE p_dynamic AS
BEGIN
  EXECUTE IMMEDIATE 'INSERT INTO tbl1 VALUES (7)';
END;

evaluate 'Case 27: NO SQL - DDL is only possible via dynamic SQL, so it is not analyzed';
CREATE OR REPLACE PROCEDURE p_ddl AS
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE t_new (x INT)';
END;

evaluate 'Case 28: NO SQL - calling another SP is not counted as SQL access';
CREATE OR REPLACE PROCEDURE p_callmod AS
BEGIN
  p_insert();
END;

evaluate 'Case 29: DBMS_OUTPUT execution path is exercised for the NO SQL procedure';
CALL p_nosql();

evaluate 'Case 30: sql_data_access from db_stored_procedure for all cases above';
SELECT sp_name, sp_type, sql_data_access
FROM db_stored_procedure
WHERE sp_name IN ('p_nosql', 'f_calc', 'p_empty', 'f_contains', 'f_func_nofrom',
                  'p_commit', 'p_rollback', 'f_setderived', 'f_view_set', 'f_reads',
                  'f_const_realtbl', 'f_dual', 'f_cursor', 'f_openfor', 'f_forloop',
                  'f_subquery', 'f_view', 'f_contains_reads', 'p_insert', 'p_update',
                  'p_delete', 'p_merge', 'p_replace', 'p_truncate', 'p_insert_select',
                  'p_mixed', 'p_dynamic', 'p_ddl', 'p_callmod')
ORDER BY sp_name;

evaluate 'Case 31: same value is exposed through information_schema.routines for every routine';
SELECT routine_name, routine_type, sql_data_access
FROM information_schema.routines
WHERE routine_name IN ('p_nosql', 'f_calc', 'p_empty', 'f_contains', 'f_func_nofrom',
                       'p_commit', 'p_rollback', 'f_setderived', 'f_view_set', 'f_reads',
                       'f_const_realtbl', 'f_dual', 'f_cursor', 'f_openfor', 'f_forloop',
                       'f_subquery', 'f_view', 'f_contains_reads', 'p_insert', 'p_update',
                       'p_delete', 'p_merge', 'p_replace', 'p_truncate', 'p_insert_select',
                       'p_mixed', 'p_dynamic', 'p_ddl', 'p_callmod')
ORDER BY routine_name;

evaluate 'Case 32: CREATE OR REPLACE re-determines sql_data_access (READS -> MODIFIES)';
CREATE OR REPLACE FUNCTION f_reads RETURN INT AS
  n INT;
BEGIN
  INSERT INTO tbl1 VALUES (5);
  SELECT count(*) INTO n FROM tbl1;
  RETURN n;
END;

SELECT sp_name, sql_data_access FROM db_stored_procedure WHERE sp_name = 'f_reads';

DROP PROCEDURE p_nosql;
DROP FUNCTION f_calc;
DROP PROCEDURE p_empty;
DROP FUNCTION f_contains;
DROP FUNCTION f_func_nofrom;
DROP PROCEDURE p_commit;
DROP PROCEDURE p_rollback;
DROP FUNCTION f_setderived;
DROP FUNCTION f_view_set;
DROP FUNCTION f_reads;
DROP FUNCTION f_const_realtbl;
DROP FUNCTION f_dual;
DROP FUNCTION f_cursor;
DROP FUNCTION f_openfor;
DROP FUNCTION f_forloop;
DROP FUNCTION f_subquery;
DROP FUNCTION f_view;
DROP FUNCTION f_contains_reads;
DROP PROCEDURE p_insert;
DROP PROCEDURE p_update;
DROP PROCEDURE p_delete;
DROP PROCEDURE p_merge;
DROP PROCEDURE p_replace;
DROP PROCEDURE p_truncate;
DROP PROCEDURE p_insert_select;
DROP PROCEDURE p_mixed;
DROP PROCEDURE p_dynamic;
DROP PROCEDURE p_ddl;
DROP PROCEDURE p_callmod;
DROP VIEW v_tbl1;
DROP VIEW v_set;
DROP TABLE IF EXISTS tbl1;
