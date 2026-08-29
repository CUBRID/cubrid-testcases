/* ============================================================
 * 1) (PL/CSQL) Literal Range Validation
 * 2) (PL/CSQL) Internal Arithmetic / Comparison Validation
 *
 * Goals
 *  - FUNCTION RETURN NUMERIC: verify it returns float numeric (domain numeric)
 *  - PROCEDURE DBMS_OUTPUT.put_line: verify output matches server SELECT output
 *  - Ensure PL/CSQL arithmetic/comparison results match server (SQL) results
 *  - Cover scale boundary (-214 ~ 252), overflow, and literal truncation (254 digits)
 * ============================================================ */

--+ server-message on
--;server-output on


evaluate '1. Mixed SQL <-> PL/CSQL variables (SELECT INTO / param / insert)';
/* ============================================================
 * 1. Mixed SQL <-> PL/CSQL variables (SELECT INTO / param / insert)
 * ============================================================ */

-- Procedure parameter printing: compare with server output for CAST(double)
DROP TABLE IF EXISTS t_pl_io;
CREATE OR REPLACE PROCEDURE plpc_print_param_1 (n NUMERIC)
AS
BEGIN
  DBMS_OUTPUT.put_line(n);
END;

CALL plpc_print_param_1(CAST(123456789.9999999999999999 AS DOUBLE));
SELECT CAST(123456789.9999999999999999 AS DOUBLE) AS server_double;
SELECT CAST(CAST(123456789.9999999999999999 AS DOUBLE) AS NUMERIC) AS server_to_numeric;

/* 99999999999999999999999.999999999999999를 double로 변환 하면 9.999999999999999E+22이 되며 이는
 * 99999999999999990000000 값과 동일함.
 * 그런데, 이 값을 numeric으로 변환하면 100000000000000000000000 값으로 되며 동일하지 않음.
 * 이는 develop 에서도 동일한 문제가 발생함!!
 * 즉, double의 부정확한 값으로 인해 numeric 값이 부정확하게 나오는 것임으로 버그가 아님!
 */
CALL plpc_print_param_1(CAST(99999999999999999999999.999999999999999 AS DOUBLE));
SELECT CAST(99999999999999999999999.999999999999999 AS DOUBLE) AS server_double;
SELECT CAST(CAST(99999999999999999999999.999999999999999 AS DOUBLE) AS NUMERIC) AS server_to_numeric;

CALL plpc_print_param_1(CAST(99999999999999990000000 AS DOUBLE));
SELECT CAST(99999999999999990000000 AS DOUBLE) AS server_double;
SELECT CAST(CAST(99999999999999990000000 AS DOUBLE) AS NUMERIC(38)) AS server_to_numeric_38;
SELECT CAST(CAST(99999999999999990000000 AS DOUBLE) AS NUMERIC) AS server_to_numeric;


-- in/out/local printing + NULL cases
/* 얘도 double의 정밀도로 인해 numeric과 결과가 다르게 나옴! */
CREATE OR REPLACE PROCEDURE plpc_inout_show_1 (out_n NUMERIC)
AS
  in_n   NUMERIC := 0.0000000000000000000000001;
  null_n NUMERIC := NULL;
BEGIN
  DBMS_OUTPUT.put_line('out : ' || out_n);
  DBMS_OUTPUT.put_line('in  : ' || in_n);
  DBMS_OUTPUT.put_line('nul : ' || null_n);
END;

CALL plpc_inout_show_1(99999999999999999999999999999999999999);
CALL plpc_inout_show_1(CAST(0.0000000000000000000000001 AS NUMERIC));
CALL plpc_inout_show_1(CAST(0.0000000000000000000000001 AS DOUBLE));
CALL plpc_inout_show_1(NULL);

SELECT CAST(0.0000000000000000000000001 AS DOUBLE) AS server_double_small;
SELECT CAST(CAST(0.0000000000000000000000001 AS DOUBLE) AS NUMERIC) AS server_double_to_numeric_small;

-- Function param/return + typeof (return must be domain numeric)
/* 얘도 double의 정밀도로 인해 numeric과 결과가 다르게 나옴! */
CREATE OR REPLACE FUNCTION plfn_echo_1 (out_n NUMERIC) RETURN NUMERIC
AS
  in_n NUMERIC := 0.0000000000000000000000001;
BEGIN
  DBMS_OUTPUT.put_line('out : ' || out_n);
  DBMS_OUTPUT.put_line('in  : ' || in_n);
  RETURN out_n;
END;

SELECT plfn_echo_1(9999999999999999999999999999999999999999) AS v,
       typeof(plfn_echo_1(9999999999999999999999999999999999999999)) AS t;

SELECT plfn_echo_1(CAST(0.0000000000000000000000001 AS NUMERIC)) AS v,
       typeof(plfn_echo_1(CAST(0.0000000000000000000000001 AS NUMERIC))) AS t;

SELECT plfn_echo_1(CAST(0.0000000000000000000000001 AS DOUBLE)) AS v,
       typeof(plfn_echo_1(CAST(0.0000000000000000000000001 AS DOUBLE))) AS t;


-- SELECT INTO with integer coercion
-- If DUAL is not available, replace "FROM dual" with a valid single-row source.
/* 얘도 double의 정밀도로 인해 numeric과 결과가 다르게 나옴! */
CREATE OR REPLACE FUNCTION plfn_select_into_int_1 (out_n NUMERIC) RETURN NUMERIC
AS
  in_i INTEGER;
  in_n NUMERIC;
BEGIN
  SELECT 0.0000000000000000000000001 INTO in_n FROM dual;
  SELECT 0.0000000000000000000000001 INTO in_i FROM dual;

  DBMS_OUTPUT.put_line('out : ' || out_n);
  DBMS_OUTPUT.put_line('in_n : ' || in_n);
  DBMS_OUTPUT.put_line('in_i : ' || in_i);

  RETURN in_n;
END;

CALL plfn_select_into_int_1(0.0000000000000000000000001);
CALL plfn_select_into_int_1(CAST(0.0000000000000000000000001 AS DOUBLE));

-- Insert storage validation via procedure
/* 얘도 double의 정밀도로 인해 numeric과 결과가 다르게 나옴! */
DROP TABLE IF EXISTS t_pl_io;
CREATE TABLE t_pl_io (col1 NUMERIC);

CREATE OR REPLACE PROCEDURE plpc_ins_1 (out_n NUMERIC)
AS
BEGIN
  INSERT INTO t_pl_io VALUES (out_n);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
END;

CALL plpc_ins_1(NULL);
CALL plpc_ins_1(0.0000000000000000000000001);
CALL plpc_ins_1(CAST(0.0000000000000000000000001 AS DOUBLE));
CALL plpc_ins_1(99999999999999999999999999999999999999);

SELECT col1, typeof(col1) FROM t_pl_io ORDER BY col1 IS NULL, col1;

DROP TABLE IF EXISTS t_pl_io;

-- Cleanup: drop all created procedures and functions
DROP PROCEDURE plpc_print_param_1;
DROP PROCEDURE plpc_inout_show_1;
DROP FUNCTION plfn_echo_1;
DROP FUNCTION plfn_select_into_int_1;
DROP PROCEDURE plpc_ins_1;

--+ server-message off
DROP TABLE IF EXISTS t_pl_io;