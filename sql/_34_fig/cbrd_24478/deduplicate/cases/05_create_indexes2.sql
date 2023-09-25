-- SET WITH DEDUPLICATE OPTION TO SHOW
set system parameters 'print_index_detail=y';
set system parameters 'deduplicate_key_level=-1';

DROP TABLE IF EXISTS t_child;
CREATE TABLE t_child (
id INTEGER NOT NULL PRIMARY KEY,
pid INTEGER NOT NULL,
val CHARACTER VARYING(1) DEFAULT 'N'
);

-- CREATING INDEX WITH UNIQUE COLUMN ADD TO NOT HAVING DEDUPLICATE OPTION
CREATE INDEX ix_val_pid_id_de14 ON t_child (val, pid DESC, id) WHERE val = 'N';
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc, func, index_of.filter_expression FROM _db_index_key WHERE index_of.index_name = 'ix_val_pid_id_de14';
SHOW CREATE TABLE t_child;
DROP INDEX ix_val_pid_id_de14 ON t_child;

-- INSERT DATA TO MAKE ONLINE INDEX AND PARALLEL
INSERT INTO t_child
SELECT rownum AS id, (rownum % 3000) + 1 AS pid, CASE WHEN rownum % 3 = 1 THEN 'Y' ELSE 'N' END AS val
FROM db_class a, db_class b, db_class c
LIMIT 110000;

set system parameters 'deduplicate_key_level=0';
CREATE INDEX ix_val_pid_de00p ON t_child (val DESC, pid DESC) WITH ONLINE PARALLEL 3;
SELECT 'DEDUPLICATE=0 INDEX CREATED' AS Step;
CREATE INDEX ix_val_pid_de04p ON t_child (val DESC, pid DESC) WITH DEDUPLICATE=4, ONLINE PARALLEL 3;
SELECT 'DEDUPLICATE=4 INDEX CREATED' AS Step;
CREATE INDEX ix_val_pid_de08p ON t_child (val, pid) WITH DEDUPLICATE=8, ONLINE PARALLEL 3 COMMENT 'invisibled';
SELECT 'DEDUPLICATE=8 INDEX CREATED AND ONLINE PARALLE' AS Step;
ALTER INDEX ix_val_pid_de08p ON t_child INVISIBLE;
SELECT index_of.class_of.class_name, index_of.index_name, key_attr_name, key_order, asc_desc, index_of.status, CASE index_of.status WHEN 2 THEN 'INVISIBLE' ELSE 'VISIBLE' END AS status  FROM _db_index_key WHERE index_of.index_name LIKE 'ix_val_pid_de%'
ORDER BY index_of.class_of.class_name, index_of.index_name, key_order, index_of.status
SHOW CREATE TABLE t_child;

DROP TABLE IF EXISTS t_child;
set system parameters 'deduplicate_key_level=-1';
set system parameters 'print_index_detail=n';
