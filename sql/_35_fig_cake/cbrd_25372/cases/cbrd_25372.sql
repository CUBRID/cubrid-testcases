-- This test case verifies the following issue: CBRD-25372.
-- Validate that no type checking occurs during view creation.

DROP TABLE IF EXISTS tbl1, tbl2, tbl3, tbl4, tbl5, tbl6, tbl7, tbl8, tbl9, tbl10, tbl11, tbl12, tbl13, tbl14, tbl15, tbl16;
DROP VIEW IF EXISTS v1_1, v1_2, v2_1, v2_2, v3_1, v3_2, v4_1, v4_2, v5_1, v5_2, v6_1, v6_2, v7_1, v7_2, v8_1, v8_2, v9_1, v9_2, v10_1, v10_2, v11_1, v11_2, v12_1, v12_2, v13_1, v13_2, v14_1, v14_2, v15_1, v15_2, v16_1, v16_2;

evaluate '1. Conversion of CHAR to NUMERIC';
-- Create a table with a single CHAR column 'flag'
CREATE TABLE tbl1 (flag CHAR(1));

-- Insert a single row into the table. The 'flag' column stores the character '1'
INSERT INTO tbl1 VALUES('1');

-- This statement works/worked fine because the `nvl(flag, '0')` expression results in '1',
-- but the expression `0+nvl(flag, '0')` forces an implicit conversion to a numeric type.
-- CUBRID will allow this view to be created without performing type checking.
CREATE VIEW v1_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(flag, '0') FROM tbl1;

-- This statement caused an error when the view is executed, not when it is created.
-- The `nvl(flag, '0')` expression returns a CHAR value ('1' or '0'), ut the view expects a NUMERIC(22) column.
-- Since no type checking occurs during view creation, the view is/was created successfully.
-- However, an error occured at runtime when the SELECT statement is executed 
-- because CUBRID will fail to convert CHAR values to NUMERIC(22). The same error should no longer occur.
CREATE VIEW v1_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(flag, '0') FROM tbl1;


evaluate '2. Conversion of NULL CHAR to NUMERIC';
CREATE TABLE tbl2 (char_col CHAR(1));
INSERT INTO tbl2 VALUES (NULL);

CREATE VIEW v2_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(char_col, '0') FROM tbl2;

CREATE VIEW v2_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(char_col, '0') FROM tbl2;


evaluate '3. Implicit Conversion from VARCHAR to NUMERIC';
CREATE TABLE tbl3 (str_col VARCHAR(10));
INSERT INTO tbl3 VALUES ('123');

CREATE VIEW v3_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(str_col, '0') FROM tbl3;

CREATE VIEW v3_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(str_col, '0') FROM tbl3;


evaluate '4. Conversion of Incompatible Strings to NUMERIC';
CREATE TABLE tbl4 (str_col VARCHAR(10));
INSERT INTO tbl4 VALUES ('abc');

CREATE VIEW v4_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(str_col, '0') FROM tbl4;

CREATE VIEW v4_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(str_col, '0') FROM tbl4;


evaluate '5. Implicit Conversion from BIT(n) to NUMERIC';
CREATE TABLE tbl5 (bit_col BIT(1));
INSERT INTO tbl5 VALUES (B'1');

CREATE VIEW v5_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(bit_col, 0) FROM tbl5;

CREATE VIEW v5_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(bit_col, 0) FROM tbl5;


evaluate '6. Implicit Conversion of TIMESTAMP to NUMERIC';
CREATE TABLE tbl6 (timestamp_col TIMESTAMP);
INSERT INTO tbl6 VALUES (CURRENT_TIMESTAMP);

CREATE VIEW v6_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(timestamp_col, CURRENT_TIMESTAMP) FROM tbl6;

CREATE VIEW v6_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(timestamp_col, CURRENT_TIMESTAMP) FROM tbl6;


evaluate '7. Implicit Conversion with DECIMAL Precision Mismatch';
CREATE TABLE tbl7 (dec_col DECIMAL(10, 2));
INSERT INTO tbl7 VALUES (12345.67);

CREATE VIEW v7_1 (sum1 NUMERIC(5, 2)) AS 
SELECT 0 + NVL(dec_col, 0) FROM tbl7;

CREATE VIEW v7_2 (sum1 NUMERIC(5, 2)) AS 
SELECT NVL(dec_col, 0) FROM tbl7;


evaluate '8. Implicit Conversion from ENUM to NUMERIC';
CREATE TABLE tbl8 (color ENUM('red', 'yellow', 'blue'));
INSERT INTO tbl8 VALUES ('red');

CREATE VIEW v8_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(color, 'yellow') FROM tbl8;

CREATE VIEW v8_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(color, 'yellow') FROM tbl8;


evaluate '9. Implicit Conversion from VARBIT to NUMERIC';
CREATE TABLE tbl9 (varbit_col BIT VARYING(8));
INSERT INTO tbl9 VALUES (B'10101010');
CREATE VIEW v9_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(varbit_col, 0) FROM tbl9;
CREATE VIEW v9_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(varbit_col, 0) FROM tbl9;


evaluate '10. Implicit Conversion from DATE to NUMERIC';
CREATE TABLE tbl10 (date_col DATE);
INSERT INTO tbl10 VALUES ('2023-10-17');

CREATE VIEW v10_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(date_col, '2023-01-01') FROM tbl10;

CREATE VIEW v10_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(date_col, '2023-01-01') FROM tbl10;


evaluate '11. Implicit Conversion from JSON to NUMERIC';
CREATE TABLE tbl11 (json_col JSON);
INSERT INTO tbl11 VALUES ('{"value": 12345}');

CREATE VIEW v11_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(CAST(json_col AS VARCHAR), '0') FROM tbl11;

CREATE VIEW v11_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(CAST(json_col AS VARCHAR), '0') FROM tbl11;


evaluate '12. Implicit Conversion from TIME to NUMERIC';
CREATE TABLE tbl12 (time_col TIME);
INSERT INTO tbl12 VALUES ('12:34:56');

CREATE VIEW v12_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(time_col, '00:00:00') FROM tbl12;

CREATE VIEW v12_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(time_col, '00:00:00') FROM tbl12;


evaluate '13. Implicit Conversion from DATETIME to NUMERIC';
CREATE TABLE tbl13 (datetime_col DATETIME);
INSERT INTO tbl13 VALUES ('2024-10-17 15:30:00');

CREATE VIEW v13_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(datetime_col, '2024-01-01 00:00:00') FROM tbl13;

CREATE VIEW v13_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(datetime_col, '2024-01-01 00:00:00') FROM tbl13;


evaluate '14. Implicit Conversion from SET to NUMERIC';
CREATE TABLE tbl14 (set_col SET(INTEGER));
INSERT INTO tbl14 VALUES ({1, 2, 3});

CREATE VIEW v14_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(set_col, 0) FROM tbl14;

CREATE VIEW v14_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(set_col, 0) FROM tbl14;


evaluate '15. Implicit Conversion from LIST to VARCHAR';
CREATE TABLE tbl15 (list_col LIST(VARCHAR(10)));
INSERT INTO tbl15 VALUES ({'a', 'b', 'c'});

CREATE VIEW v15_1 (str_col VARCHAR(50)) AS 
SELECT NVL(list_col, 'empty') FROM tbl15;

CREATE VIEW v15_2 (str_col VARCHAR(50)) AS 
SELECT list_col FROM tbl15;


evaluate '16. Implicit Conversion from TIMESTAMPTZ to NUMERIC';
CREATE TABLE tbl16 (timestamptz_col TIMESTAMPTZ);
INSERT INTO tbl16 VALUES ('2024-10-17 15:30:00+02:00');

CREATE VIEW v16_1 (sum1 NUMERIC(22)) AS 
SELECT 0 + NVL(timestamptz_col, '2024-01-01 00:00:00+00:00') FROM tbl16;

CREATE VIEW v16_2 (sum1 NUMERIC(22)) AS 
SELECT NVL(timestamptz_col, '2024-01-01 00:00:00+00:00') FROM tbl16;


DROP TABLE IF EXISTS tbl1, tbl2, tbl3, tbl4, tbl5, tbl6, tbl7, tbl8, tbl9, tbl10, tbl11, tbl12, tbl13, tbl14, tbl15, tbl16;
DROP VIEW IF EXISTS v1_1, v1_2, v2_1, v2_2, v3_1, v3_2, v4_1, v4_2, v5_1, v5_2, v6_1, v6_2, v7_1, v7_2, v8_1, v8_2, v9_1, v9_2, v10_1, v10_2, v11_1, v11_2, v12_1, v12_2, v13_1, v13_2, v14_1, v14_2, v15_1, v15_2, v16_1, v16_2;