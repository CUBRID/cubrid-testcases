/**
 * This test case verifies CBRD-27628 (11.4 only - already fixed on develop
 * by CBRD-26354, so this TC has no effect there): a host-variable LIMIT/
 * OFFSET on ORDER BY <pk> DESC must pick the same PK-descending order-by-
 * skip index scan a constant LIMIT already does, not a full scan + sort.
 * The misplan is cost-based and surfaces once the index scan's cost is far
 * enough above the full-scan-plus-sort cost; col_c rides along in the
 * SELECT so the chosen index cannot cover it, forcing that cost - unlike
 * the other columns it is a constant literal through every doubling
 * INSERT, so it alone is scan-order independent.
 *
 * Coverage:
 * 1. host-variable LIMIT+OFFSET - the issue's exact repro (regression)
 * 2. constant LIMIT - already picked this plan; must keep matching
 * 3. host-variable LIMIT alone (no OFFSET) - rewrites differently from
 *    case 1; the fix's own PR measured this form as regressed too
 * 4. host-variable LIMIT on a join - the fix reuses the constant-LIMIT
 *    comparison here too, which can change join plans; asserts both agree
 */

drop table if exists tbl;
CREATE TABLE tbl (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  enum_col1 ENUM('A','B','C','D'), enum_col2 ENUM('X','Y','Z'),
  dt_col DATETIME, col_a VARCHAR(100), col_b INT,
  col_c VARCHAR(200), col_d VARCHAR(200), col_e SET(VARCHAR(20))
);

drop table if exists tbl_u;
CREATE TABLE tbl_u (id BIGINT);
INSERT INTO tbl_u VALUES (1), (2), (3), (4), (5);

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

COMMIT;

UPDATE STATISTICS ON tbl WITH FULLSCAN;

evaluate 'Case 1: a host-variable LIMIT/OFFSET must pick the PK-descending order-by-skip scan';
--@queryplan
PREPARE st FROM 'SELECT id, col_c FROM tbl ORDER BY id DESC LIMIT ? OFFSET ?';
EXECUTE st USING 30, 0;
deallocate prepare st;

evaluate 'Case 2: a constant LIMIT already picks the same plan and must keep matching';
--@queryplan
SELECT id, col_c FROM tbl ORDER BY id DESC LIMIT 30 OFFSET 0;

evaluate 'Case 3: a host-variable LIMIT alone must pick the PK-descending order-by-skip scan';
--@queryplan
PREPARE st FROM 'SELECT id, col_c FROM tbl ORDER BY id DESC LIMIT ?';
EXECUTE st USING 30;
deallocate prepare st;

evaluate 'Case 4: a host-variable LIMIT on a join must pick the same plan as a constant LIMIT';
--@queryplan
PREPARE st FROM 'SELECT t.id, t.col_c FROM tbl t, tbl_u u WHERE t.id = u.id ORDER BY t.id DESC LIMIT ?';
EXECUTE st USING 3;
deallocate prepare st;
--@queryplan
SELECT t.id, t.col_c FROM tbl t, tbl_u u WHERE t.id = u.id ORDER BY t.id DESC LIMIT 3;

drop table if exists tbl_u;
drop table if exists tbl;
