set system parameters 'create_table_reuseoid=no';
-- CUBRIDSUS_BUG 3339
autocommit off;
CREATE TABLE tbl_3 (id int);
CREATE TABLE tbl_3_ref (o tbl_3);

INSERT INTO tbl_3 VALUES (22) into :tbl_3_inst;
INSERT INTO tbl_3_ref VALUES (:tbl_3_inst);

-- return 22
SELECT o.id FROM tbl_3_ref;
COMMIT;

TRUNCATE tbl_3;

-- return NULL
SELECT o.id FROM tbl_3_ref;

ROLLBACK;

-- return 22
SELECT o.id FROM tbl_3_ref;

DROP TABLE tbl_3_ref;
DROP TABLE tbl_3;
COMMIT;

CREATE TABLE tbl_3 (id int);
CREATE TABLE tbl_3_ref (o tbl_3);

INSERT INTO tbl_3 VALUES (22) into :tbl_3_inst;
INSERT INTO tbl_3_ref VALUES (:tbl_3_inst);

-- return 22
SELECT o.id FROM tbl_3_ref;
COMMIT;

TRUNCATE tbl_3;

-- return NULL
SELECT o.id FROM tbl_3_ref;

ROLLBACK;

-- return 22
SELECT o.id FROM tbl_3_ref;

DROP TABLE tbl_3_ref;
DROP TABLE tbl_3;
COMMIT;

autocommit on;
set system parameters 'create_table_reuseoid=yes';
