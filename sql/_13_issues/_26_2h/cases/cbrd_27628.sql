/**
 * This test case verifies CBRD-27628 (11.4 only - already fixed on develop
 * by CBRD-26354, so this TC has no effect there): a host-variable LIMIT/
 * OFFSET on ORDER BY <pk> DESC must pick the same PK-descending order-by-
 * skip index scan a constant LIMIT already does, not a full scan + sort.
 * The misplan is cost-based, so it only surfaces once the index scan's
 * cost is far enough above the full-scan-plus-sort cost (per the issue,
 * about 2.6M rows) - this is the issue's own confirmed repro scale.
 *
 * Coverage:
 * 1. host-variable LIMIT+OFFSET - the issue's exact repro (regression)
 * 2. constant LIMIT - already picked this plan; must keep matching
 */

drop table if exists tbl;
CREATE TABLE tbl (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  enum_col1 ENUM('A','B','C','D'), enum_col2 ENUM('X','Y','Z'),
  dt_col DATETIME, col_a VARCHAR(100), col_b INT,
  col_c VARCHAR(200), col_d VARCHAR(200), col_e SET(VARCHAR(20))
);

CREATE INDEX i_tbl_dt ON tbl (dt_col);
CREATE INDEX i_tbl_a ON tbl (col_a);
CREATE INDEX i_tbl_b ON tbl (col_b);

INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e)
  VALUES (1, 2, SYSDATETIME, 'user_1', 1, 'some message text here', NULL, {'a','b'});

INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;
INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e) SELECT (id % 4) + 1, (id % 3) + 1, dt_col + id, 'user_' || (id % 5000), id % 100000, col_c, CASE WHEN id % 7 = 0 THEN 'dval' END, col_e FROM tbl;

INSERT INTO tbl (enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e)
  SELECT enum_col1, enum_col2, dt_col, col_a, col_b, col_c, col_d, col_e FROM tbl WHERE id <= 530502;

COMMIT;

UPDATE STATISTICS ON tbl WITH FULLSCAN;

evaluate 'Case 1: a host-variable LIMIT/OFFSET must pick the PK-descending order-by-skip scan';
--@queryplan
PREPARE st FROM 'SELECT id FROM tbl ORDER BY id DESC LIMIT ? OFFSET ?';
EXECUTE st USING 30, 0;
deallocate prepare st;

evaluate 'Case 2: a constant LIMIT already picks the same plan and must keep matching';
SELECT id FROM tbl ORDER BY id DESC LIMIT 30 OFFSET 0;

drop table if exists tbl;
