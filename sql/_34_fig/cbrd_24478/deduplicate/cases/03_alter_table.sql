-- SET WITH DEDUPLICATE OPTION TO SHOW 
set system parameters 'print_index_detail=y';
set system parameters 'deduplicate_key_level=-1';

set system parameters 'deduplicate_key_level=8';
DROP TABLE IF EXISTS t_parent;
CREATE TABLE t_parent (
id INTEGER NOT NULL PRIMARY KEY,
val CHARACTER VARYING(1) DEFAULT 'N');
ALTER TABLE t_parent ADD INDEX ix_val_de06(val) WITH DEDUPLICATE=6;
SHOW CREATE TABLE t_parent;

ALTER TABLE t_parent CHANGE val val2 VARCHAR(2) NOT NULL FIRST;
SHOW CREATE TABLE t_parent;

set system parameters 'deduplicate_key_level=8';
DROP TABLE IF EXISTS t_parent;
CREATE TABLE t_parent (
id INTEGER NOT NULL PRIMARY KEY, 
val CHARACTER VARYING(11),  
INDEX ix_val_de08 (val));
INSERT INTO t_parent VALUES (1,-2147483648),(2,2147483647);
ALTER TABLE t_parent MODIFY val INT NOT NULL DEFAULT 0;
SELECT id,val FROM t_parent;
SHOW CREATE TABLE t_parent;

-- PK/UK deuplicated
ALTER TABLE t_parent DROP PRIMARY KEY;
ALTER TABLE t_parent ADD INDEX ix_id_de10(id) WITH DEDUPLICATE=10;
SHOW CREATE TABLE t_parent;
-- Fail
ALTER TABLE t_parent ADD CONSTRAINT PRIMARY KEY(id);

set system parameters 'deduplicate_key_level=10';
DROP TABLE IF EXISTS t_parent;
CREATE TABLE t_parent (
id INTEGER NOT NULL PRIMARY KEY,
val CHARACTER VARYING(11));
SHOW CREATE TABLE t_parent;
-- Fail
ALTER TABLE t_parent ADD INDEX ix_id_de12(id) WITH DEDUPLICATE=12;

ALTER TABLE t_parent DROP PRIMARY KEY;
ALTER TABLE t_parent ADD UNIQUE INDEX ux_id(id);
-- Deduplicate option ignored
ALTER TABLE t_parent ADD INDEX ux_id_val_de14(id,val) WITH DEDUPLICATE=14;
SHOW CREATE TABLE t_parent;
-- Fail
ALTER TABLE t_parent ADD UNIQUE INDEX ux_id(id) WITH DEDUPLICATE=14;

DROP TABLE IF EXISTS t_parent;
set system parameters 'deduplicate_key_level=-1';
set system parameters 'print_index_detail=n';
