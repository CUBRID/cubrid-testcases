-- CBRD-26273 - ALTER TABLE constraints/column drop replication behavior tests

-- 1: REPLICATION ON. DROP PRIMARY KEY (no alternate RK)
-- ha_repl result: HA constraint violation
evaluate '1. repl_on_drop_pk1';
drop table if exists repl_on_drop_pk1;
CREATE TABLE repl_on_drop_pk1(a VARCHAR(50) PRIMARY KEY, b INT)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk1') ORDER BY 1;
ALTER TABLE repl_on_drop_pk1 DROP PRIMARY KEY;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk1') ORDER BY 1;
insert into repl_on_drop_pk1 values ('test1', 100);
insert into repl_on_drop_pk1 values ('test1', 200);
select * from repl_on_drop_pk1;
drop table if exists repl_on_drop_pk1;

-- 2: REPLICATION ON. DROP PRIMARY KEY (remaining UNIQUE)
-- ha_repl result: HA constraint violation
evaluate '2. repl_on_drop_pk2';
drop table if exists repl_on_drop_pk2;
CREATE TABLE repl_on_drop_pk2(a BIGINT PRIMARY KEY, b CHAR(10) UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk2') ORDER BY 1;
ALTER TABLE repl_on_drop_pk2 DROP PRIMARY KEY;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk2') ORDER BY 1;
insert into repl_on_drop_pk2 values (1, 'test2');
insert into repl_on_drop_pk2 values (1, NULL);
select * from repl_on_drop_pk2;
drop table if exists repl_on_drop_pk2;

-- 3: REPLICATION ON. DROP PRIMARY KEY (remaining NOT NULL UNIQUE)
-- ha_repl result: success, replicated
evaluate '3. repl_on_drop_pk3';
drop table if exists repl_on_drop_pk3;
CREATE TABLE repl_on_drop_pk3(a SMALLINT PRIMARY KEY, b VARCHAR(20) NOT NULL UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk3') ORDER BY 1;
ALTER TABLE repl_on_drop_pk3 DROP PRIMARY KEY;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk3') ORDER BY 1;
insert into repl_on_drop_pk3 values (1, 'test3');
insert into repl_on_drop_pk3 values (1, 'dup3');
select * from repl_on_drop_pk3;
drop table if exists repl_on_drop_pk3;

-- 4: REPLICATION OFF. DROP PRIMARY KEY (no alternate RK)
-- ha_repl result: success, no replication
evaluate '4. repl_off_drop_pk1';
drop table if exists repl_off_drop_pk1;
CREATE TABLE repl_off_drop_pk1(a DATE PRIMARY KEY, b VARCHAR(20))REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_pk1') ORDER BY 1;
ALTER TABLE repl_off_drop_pk1 DROP PRIMARY KEY;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_pk1') ORDER BY 1;
insert into repl_off_drop_pk1 values (DATE '2026-03-19', 'test4');
insert into repl_off_drop_pk1 values (DATE '2026-03-19', 'dup4');
select * from repl_off_drop_pk1;
drop table if exists repl_off_drop_pk1;

-- 5: REPLICATION OFF. DROP PRIMARY KEY (remaining UNIQUE)
-- ha_repl result: success, no replication
evaluate '5. repl_off_drop_pk2';
drop table if exists repl_off_drop_pk2;
CREATE TABLE repl_off_drop_pk2(a TIMESTAMP PRIMARY KEY, b VARCHAR(20) UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_pk2') ORDER BY 1;
ALTER TABLE repl_off_drop_pk2 DROP PRIMARY KEY;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_pk2') ORDER BY 1;
insert into repl_off_drop_pk2 values (TIMESTAMP '2026-03-19 10:20:30', 'test5');
insert into repl_off_drop_pk2 values (TIMESTAMP '2026-03-19 10:20:30', NULL);
select * from repl_off_drop_pk2;
drop table if exists repl_off_drop_pk2;

-- 6: REPLICATION OFF. DROP PRIMARY KEY (remaining NOT NULL UNIQUE)
-- ha_repl result: success, no replication
evaluate '6. repl_off_drop_pk3';
drop table if exists repl_off_drop_pk3;
CREATE TABLE repl_off_drop_pk3(a DOUBLE PRIMARY KEY, b VARCHAR(30) NOT NULL UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_pk3') ORDER BY 1;
ALTER TABLE repl_off_drop_pk3 DROP PRIMARY KEY;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_pk3') ORDER BY 1;
insert into repl_off_drop_pk3 values (1.0, 'test6');
insert into repl_off_drop_pk3 values (1.0, 'dup6');
select * from repl_off_drop_pk3;
drop table if exists repl_off_drop_pk3;

-- 7: REPLICATION ON. DROP PK constraint (no alternate RK)
-- ha_repl result: HA constraint violation
evaluate '7. repl_on_drop_constraint_pk1';
drop table if exists repl_on_drop_constraint_pk1;
CREATE TABLE repl_on_drop_constraint_pk1(a VARCHAR(20) PRIMARY KEY, b INT)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_pk1') ORDER BY 1;
ALTER TABLE repl_on_drop_constraint_pk1 DROP CONSTRAINT pk_repl_on_drop_constraint_pk1_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_pk1') ORDER BY 1;
insert into repl_on_drop_constraint_pk1 values ('test7', 100);
insert into repl_on_drop_constraint_pk1 values ('test7', 200);
select * from repl_on_drop_constraint_pk1;
drop table if exists repl_on_drop_constraint_pk1;

-- 8: REPLICATION ON. DROP PK constraint (remaining UNIQUE)
-- ha_repl result: HA constraint violation
evaluate '8. repl_on_drop_constraint_pk2';
drop table if exists repl_on_drop_constraint_pk2;
CREATE TABLE repl_on_drop_constraint_pk2(a BIGINT PRIMARY KEY, b CHAR(8) UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_pk2') ORDER BY 1;
ALTER TABLE repl_on_drop_constraint_pk2 DROP CONSTRAINT pk_repl_on_drop_constraint_pk2_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_pk2') ORDER BY 1;
insert into repl_on_drop_constraint_pk2 values (1, 'test8');
insert into repl_on_drop_constraint_pk2 values (1, NULL);
select * from repl_on_drop_constraint_pk2;
drop table if exists repl_on_drop_constraint_pk2;

-- 9: REPLICATION ON. DROP PK constraint (remaining NOT NULL UNIQUE)
-- ha_repl result: success, replicated
evaluate '9. repl_on_drop_constraint_pk3';
drop table if exists repl_on_drop_constraint_pk3;
CREATE TABLE repl_on_drop_constraint_pk3(a SMALLINT PRIMARY KEY, b VARCHAR(20) NOT NULL UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_pk3') ORDER BY 1;
ALTER TABLE repl_on_drop_constraint_pk3 DROP CONSTRAINT pk_repl_on_drop_constraint_pk3_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_pk3') ORDER BY 1;
insert into repl_on_drop_constraint_pk3 values (1, 'test9');
insert into repl_on_drop_constraint_pk3 values (1, 'dup9');
select * from repl_on_drop_constraint_pk3;
drop table if exists repl_on_drop_constraint_pk3;

-- 10: REPLICATION OFF. DROP PK constraint (no alternate RK)
-- ha_repl result: success, no replication
evaluate '10. repl_off_drop_constraint_pk1';
drop table if exists repl_off_drop_constraint_pk1;
CREATE TABLE repl_off_drop_constraint_pk1(a DATE PRIMARY KEY, b VARCHAR(20))REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_pk1') ORDER BY 1;
ALTER TABLE repl_off_drop_constraint_pk1 DROP CONSTRAINT pk_repl_off_drop_constraint_pk1_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_pk1') ORDER BY 1;
insert into repl_off_drop_constraint_pk1 values (DATE '2026-03-19', 'test10');
insert into repl_off_drop_constraint_pk1 values (DATE '2026-03-19', 'dup10');
select * from repl_off_drop_constraint_pk1;
drop table if exists repl_off_drop_constraint_pk1;

-- 11: REPLICATION OFF. DROP PK constraint (remaining UNIQUE)
-- ha_repl result: success, no replication
evaluate '11. repl_off_drop_constraint_pk2';
drop table if exists repl_off_drop_constraint_pk2;
CREATE TABLE repl_off_drop_constraint_pk2(a TIMESTAMP PRIMARY KEY, b VARCHAR(20) UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_pk2') ORDER BY 1;
ALTER TABLE repl_off_drop_constraint_pk2 DROP CONSTRAINT pk_repl_off_drop_constraint_pk2_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_pk2') ORDER BY 1;
insert into repl_off_drop_constraint_pk2 values (TIMESTAMP '2026-03-19 10:20:30', 'test11');
insert into repl_off_drop_constraint_pk2 values (TIMESTAMP '2026-03-19 10:20:30', 'dup11');
select * from repl_off_drop_constraint_pk2;
drop table if exists repl_off_drop_constraint_pk2;

-- 12: REPLICATION OFF. DROP PK constraint (remaining NOT NULL UNIQUE)
-- ha_repl result: success, no replication
evaluate '12. repl_off_drop_constraint_pk3';
drop table if exists repl_off_drop_constraint_pk3;
CREATE TABLE repl_off_drop_constraint_pk3(a DOUBLE PRIMARY KEY, b VARCHAR(30) NOT NULL UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_pk3') ORDER BY 1;
ALTER TABLE repl_off_drop_constraint_pk3 DROP CONSTRAINT pk_repl_off_drop_constraint_pk3_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_pk3') ORDER BY 1;
insert into repl_off_drop_constraint_pk3 values (3.14, 'test12');
insert into repl_off_drop_constraint_pk3 values (3.14, 'dup12');
select * from repl_off_drop_constraint_pk3;
drop table if exists repl_off_drop_constraint_pk3;

-- 13: REPLICATION ON. DROP NOT NULL UNIQUE constraint (no alternate RK)
-- ha_repl result: HA constraint violation
evaluate '13. repl_on_drop_constraint_unique1';
drop table if exists repl_on_drop_constraint_unique1;
CREATE TABLE repl_on_drop_constraint_unique1(a VARCHAR(50) NOT NULL UNIQUE, b INT)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique1') ORDER BY 1;
ALTER TABLE repl_on_drop_constraint_unique1 DROP CONSTRAINT u_repl_on_drop_constraint_unique1_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique1') ORDER BY 1;
insert into repl_on_drop_constraint_unique1 values ('test13', 100);
insert into repl_on_drop_constraint_unique1 values ('test13', 200);
select * from repl_on_drop_constraint_unique1;
drop table if exists repl_on_drop_constraint_unique1;

-- 14: REPLICATION ON. DROP NOT NULL UNIQUE constraint (remaining UNIQUE)
-- ha_repl result: HA constraint violation
evaluate '14. repl_on_drop_constraint_unique2';
drop table if exists repl_on_drop_constraint_unique2;
CREATE TABLE repl_on_drop_constraint_unique2(a DECIMAL(10,2) NOT NULL UNIQUE, b CHAR(10) UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique2') ORDER BY 1;
ALTER TABLE repl_on_drop_constraint_unique2 DROP CONSTRAINT u_repl_on_drop_constraint_unique2_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique2') ORDER BY 1;
insert into repl_on_drop_constraint_unique2 values (10.00, 'test14');
insert into repl_on_drop_constraint_unique2 values (10.00, 'dup14');
select * from repl_on_drop_constraint_unique2;
drop table if exists repl_on_drop_constraint_unique2;

-- 15: REPLICATION ON. DROP NOT NULL UNIQUE constraint (remaining NOT NULL UNIQUE)
-- ha_repl result: success, replicated
evaluate '15. repl_on_drop_constraint_unique3';
drop table if exists repl_on_drop_constraint_unique3;
CREATE TABLE repl_on_drop_constraint_unique3(a VARCHAR(30) NOT NULL UNIQUE, b INT NOT NULL UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique3') ORDER BY 1;
ALTER TABLE repl_on_drop_constraint_unique3 DROP CONSTRAINT u_repl_on_drop_constraint_unique3_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique3') ORDER BY 1;
insert into repl_on_drop_constraint_unique3 values ('test15', 1);
insert into repl_on_drop_constraint_unique3 values ('test15', 2);
select * from repl_on_drop_constraint_unique3;
drop table if exists repl_on_drop_constraint_unique3;

-- 16: REPLICATION ON. DROP NOT NULL UNIQUE constraint (PRIMARY KEY as alternate RK)
-- ha_repl result: success, replicated
evaluate '16. repl_on_drop_constraint_unique4';
drop table if exists repl_on_drop_constraint_unique4;
CREATE TABLE repl_on_drop_constraint_unique4(a VARCHAR(40) NOT NULL UNIQUE, b BIGINT PRIMARY KEY)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique4') ORDER BY 1;
ALTER TABLE repl_on_drop_constraint_unique4 DROP CONSTRAINT u_repl_on_drop_constraint_unique4_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_constraint_unique4') ORDER BY 1;
insert into repl_on_drop_constraint_unique4 values ('test16', 1);
insert into repl_on_drop_constraint_unique4 values ('test16', 2);
select * from repl_on_drop_constraint_unique4;
drop table if exists repl_on_drop_constraint_unique4;

-- 17: REPLICATION OFF. DROP NOT NULL UNIQUE constraint (no alternate RK)
-- ha_repl result: success, no replication
evaluate '17. repl_off_drop_constraint_unique1';
drop table if exists repl_off_drop_constraint_unique1;
CREATE TABLE repl_off_drop_constraint_unique1(a VARCHAR(50) NOT NULL UNIQUE, b INT)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique1') ORDER BY 1;
ALTER TABLE repl_off_drop_constraint_unique1 DROP CONSTRAINT u_repl_off_drop_constraint_unique1_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique1') ORDER BY 1;
insert into repl_off_drop_constraint_unique1 values ('test17', 100);
insert into repl_off_drop_constraint_unique1 values ('test17', 200);
select * from repl_off_drop_constraint_unique1;
drop table if exists repl_off_drop_constraint_unique1;

-- 18: REPLICATION OFF. DROP NOT NULL UNIQUE constraint (remaining UNIQUE)
-- ha_repl result: success, no replication
evaluate '18. repl_off_drop_constraint_unique2';
drop table if exists repl_off_drop_constraint_unique2;
CREATE TABLE repl_off_drop_constraint_unique2(a DECIMAL(10,2) NOT NULL UNIQUE, b VARCHAR(20) UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique2') ORDER BY 1;
ALTER TABLE repl_off_drop_constraint_unique2 DROP CONSTRAINT u_repl_off_drop_constraint_unique2_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique2') ORDER BY 1;
insert into repl_off_drop_constraint_unique2 values (20.00, 'test18');
insert into repl_off_drop_constraint_unique2 values (20.00, NULL);
select * from repl_off_drop_constraint_unique2;
drop table if exists repl_off_drop_constraint_unique2;

-- 19: REPLICATION OFF. DROP NOT NULL UNIQUE constraint (remaining NOT NULL UNIQUE)
-- ha_repl result: success, no replication
evaluate '19. repl_off_drop_constraint_unique3';
drop table if exists repl_off_drop_constraint_unique3;
CREATE TABLE repl_off_drop_constraint_unique3(a VARCHAR(30) NOT NULL UNIQUE, b VARCHAR(20) NOT NULL UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique3') ORDER BY 1;
ALTER TABLE repl_off_drop_constraint_unique3 DROP CONSTRAINT u_repl_off_drop_constraint_unique3_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique3') ORDER BY 1;
insert into repl_off_drop_constraint_unique3 values ('def', 'test19');
insert into repl_off_drop_constraint_unique3 values ('def', 'dup19');
select * from repl_off_drop_constraint_unique3;
drop table if exists repl_off_drop_constraint_unique3;

-- 20: REPLICATION OFF. DROP NOT NULL UNIQUE constraint (PRIMARY KEY as alternate RK)
-- ha_repl result: success, no replication
evaluate '20. repl_off_drop_constraint_unique4';
drop table if exists repl_off_drop_constraint_unique4;
CREATE TABLE repl_off_drop_constraint_unique4(a VARCHAR(40) NOT NULL UNIQUE, b BIGINT PRIMARY KEY)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique4') ORDER BY 1;
ALTER TABLE repl_off_drop_constraint_unique4 DROP CONSTRAINT u_repl_off_drop_constraint_unique4_a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_constraint_unique4') ORDER BY 1;
insert into repl_off_drop_constraint_unique4 values ('test20', 2);
insert into repl_off_drop_constraint_unique4 values ('test20', 3);
select * from repl_off_drop_constraint_unique4;
drop table if exists repl_off_drop_constraint_unique4;

-- 21: REPLICATION ON. DROP PK COLUMN : error (cannot drop PK attribute)
-- ha_repl result: error (cannot drop PK attribute)
evaluate '21. repl_on_drop_pk_column1';
drop table if exists repl_on_drop_pk_column1;
CREATE TABLE repl_on_drop_pk_column1(a INT PRIMARY KEY, b VARCHAR(20))REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column1') ORDER BY 1;
ALTER TABLE repl_on_drop_pk_column1 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column1') ORDER BY 1;
insert into repl_on_drop_pk_column1 values (21, 'test21');
--error: duplicate key value violates unique constraint
insert into repl_on_drop_pk_column1 values (21, 'dup21');
select * from repl_on_drop_pk_column1;
drop table if exists repl_on_drop_pk_column1;

-- 22: REPLICATION ON. DROP PK COLUMN : error (cannot drop PK attribute)
-- ha_repl result: error (cannot drop PK attribute)
evaluate '22. repl_on_drop_pk_column2';
drop table if exists repl_on_drop_pk_column2;
CREATE TABLE repl_on_drop_pk_column2(a INT PRIMARY KEY, b VARCHAR(20) UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column2') ORDER BY 1;
ALTER TABLE repl_on_drop_pk_column2 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column2') ORDER BY 1;
insert into repl_on_drop_pk_column2 values (22, 'test22');
--error: duplicate key value violates unique constraint
insert into repl_on_drop_pk_column2 values (22, 'dup22');
select * from repl_on_drop_pk_column2;
drop table if exists repl_on_drop_pk_column2;

-- 23: REPLICATION ON. DROP PK COLUMN : error (cannot drop PK attribute)
-- ha_repl result: error (cannot drop PK attribute)
evaluate '23. repl_on_drop_pk_column3';
drop table if exists repl_on_drop_pk_column3;
CREATE TABLE repl_on_drop_pk_column3(a INT PRIMARY KEY, b VARCHAR(20) NOT NULL UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column3') ORDER BY 1;
ALTER TABLE repl_on_drop_pk_column3 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column3') ORDER BY 1;
insert into repl_on_drop_pk_column3 values (23, 'test23');
--error: duplicate key value violates unique constraint
insert into repl_on_drop_pk_column3 values (23, 'dup23');
select * from repl_on_drop_pk_column3;
drop table if exists repl_on_drop_pk_column3;

-- 24: REPLICATION ON. DROP PK COLUMN : error (cannot drop PK attribute)
-- ha_repl result: error (cannot drop PK attribute)
evaluate '24. repl_on_drop_pk_column4';
drop table if exists repl_on_drop_pk_column4;
CREATE TABLE repl_on_drop_pk_column4(a INT, b VARCHAR(20), primary key (a,b))REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column4') ORDER BY 1;
ALTER TABLE repl_on_drop_pk_column4 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_pk_column4') ORDER BY 1;
insert into repl_on_drop_pk_column4 values (24, 'test24');
--error: duplicate key value violates unique constraint
insert into repl_on_drop_pk_column4 values (24, 'abc24');
select * from repl_on_drop_pk_column4;
drop table if exists repl_on_drop_pk_column4;

-- 25: REPLICATION ON. DROP NOT NULL UNIQUE COLUMN (no alternate RK)
-- ha_repl result: HA constraint violation
evaluate '25. repl_on_drop_column_unique1';
drop table if exists repl_on_drop_column_unique1;
CREATE TABLE repl_on_drop_column_unique1(a VARCHAR(50) NOT NULL UNIQUE, b INT)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique1') ORDER BY 1;
ALTER TABLE repl_on_drop_column_unique1 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique1') ORDER BY 1;
insert into repl_on_drop_column_unique1(b) values (100);
select * from repl_on_drop_column_unique1;
drop table if exists repl_on_drop_column_unique1;

-- 26: REPLICATION ON. DROP NOT NULL UNIQUE COLUMN (remaining UNIQUE)
-- ha_repl result: HA constraint violation
evaluate '26. repl_on_drop_column_unique2';
drop table if exists repl_on_drop_column_unique2;
CREATE TABLE repl_on_drop_column_unique2(a DECIMAL(10,2) NOT NULL UNIQUE, b CHAR(10) UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique2') ORDER BY 1;
ALTER TABLE repl_on_drop_column_unique2 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique2') ORDER BY 1;
insert into repl_on_drop_column_unique2(b) values ('test26');
select * from repl_on_drop_column_unique2;
drop table if exists repl_on_drop_column_unique2;

-- 27: REPLICATION ON. DROP NOT NULL UNIQUE COLUMN (remaining NOT NULL UNIQUE)
-- ha_repl result: success, replicated
evaluate '27. repl_on_drop_column_unique3';
drop table if exists repl_on_drop_column_unique3;
CREATE TABLE repl_on_drop_column_unique3(a VARCHAR(30) NOT NULL UNIQUE, b VARCHAR(20) NOT NULL UNIQUE)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique3') ORDER BY 1;
ALTER TABLE repl_on_drop_column_unique3 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique3') ORDER BY 1;
insert into repl_on_drop_column_unique3(b) values ('test27');
select * from repl_on_drop_column_unique3;
drop table if exists repl_on_drop_column_unique3;

-- 28: REPLICATION ON. DROP NOT NULL UNIQUE COLUMN (PRIMARY KEY as alternate RK)
-- ha_repl result: success, replicated
evaluate '28. repl_on_drop_column_unique4';
drop table if exists repl_on_drop_column_unique4;
CREATE TABLE repl_on_drop_column_unique4(a VARCHAR(40) NOT NULL UNIQUE, b BIGINT PRIMARY KEY)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique4') ORDER BY 1;
ALTER TABLE repl_on_drop_column_unique4 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_on_drop_column_unique4') ORDER BY 1;
insert into repl_on_drop_column_unique4(b) values (1000);
select * from repl_on_drop_column_unique4;
drop table if exists repl_on_drop_column_unique4;

-- 29: REPLICATION OFF. DROP NOT NULL UNIQUE COLUMN (no alternate RK)
-- ha_repl result: success, no replication
evaluate '29. repl_off_drop_column_unique1';
drop table if exists repl_off_drop_column_unique1;
CREATE TABLE repl_off_drop_column_unique1(a INT NOT NULL UNIQUE, b VARCHAR(20))REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique1') ORDER BY 1;
ALTER TABLE repl_off_drop_column_unique1 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique1') ORDER BY 1;
insert into repl_off_drop_column_unique1(b) values ('test29');
select * from repl_off_drop_column_unique1;
drop table if exists repl_off_drop_column_unique1;

-- 30: REPLICATION OFF. DROP NOT NULL UNIQUE COLUMN (remaining UNIQUE)
-- ha_repl result: success, no replication
evaluate '30. repl_off_drop_column_unique2';
drop table if exists repl_off_drop_column_unique2;
CREATE TABLE repl_off_drop_column_unique2(a DECIMAL(10,2) NOT NULL UNIQUE, b VARCHAR(20) UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique2') ORDER BY 1;
ALTER TABLE repl_off_drop_column_unique2 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique2') ORDER BY 1;
insert into repl_off_drop_column_unique2(b) values ('test30');
select * from repl_off_drop_column_unique2;
drop table if exists repl_off_drop_column_unique2;

-- 31: REPLICATION OFF. DROP NOT NULL UNIQUE COLUMN (remaining NOT NULL UNIQUE)
-- ha_repl result: success, no replication
evaluate '31. repl_off_drop_column_unique3';
drop table if exists repl_off_drop_column_unique3;
CREATE TABLE repl_off_drop_column_unique3(a VARCHAR(30) NOT NULL UNIQUE, b VARCHAR(20) NOT NULL UNIQUE)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique3') ORDER BY 1;
ALTER TABLE repl_off_drop_column_unique3 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique3') ORDER BY 1;
insert into repl_off_drop_column_unique3(b) values ('test31');
select * from repl_off_drop_column_unique3;
drop table if exists repl_off_drop_column_unique3;

-- 32: REPLICATION OFF. DROP NOT NULL UNIQUE COLUMN (PRIMARY KEY as alternate RK)
-- ha_repl result: success, no replication
evaluate '32. repl_off_drop_column_unique4';
drop table if exists repl_off_drop_column_unique4;
CREATE TABLE repl_off_drop_column_unique4(a INT NOT NULL UNIQUE, b VARCHAR(20) PRIMARY KEY)REPLICATION OFF;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique4') ORDER BY 1;
ALTER TABLE repl_off_drop_column_unique4 DROP COLUMN a;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('repl_off_drop_column_unique4') ORDER BY 1;
insert into repl_off_drop_column_unique4(b) values ('test32');
select * from repl_off_drop_column_unique4;
drop table if exists repl_off_drop_column_unique4;

-- 33: REPLICATION ON. Multi-ALTER: DROP PRIMARY KEY(a), ADD PRIMARY KEY(b)
-- ha_repl result: success, replicated
evaluate '33. multi_alter_pk_ok';
drop table if exists multi_alter_pk_ok;
CREATE TABLE multi_alter_pk_ok(a BIGINT PRIMARY KEY, b VARCHAR(20), c INT)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('multi_alter_pk_ok') ORDER BY 1;
ALTER TABLE multi_alter_pk_ok DROP PRIMARY KEY, ADD CONSTRAINT pk_multi_alter_pk_ok_b PRIMARY KEY(b);
SELECT class_name, index_name FROM db_index WHERE class_name IN ('multi_alter_pk_ok') ORDER BY 1;
insert into multi_alter_pk_ok values (1, 'test33', 1000);
insert into multi_alter_pk_ok values (1, 'dup33', 2000);
--error: duplicate key value violates unique constraint
insert into multi_alter_pk_ok values (3, 'dup33', 3000);
select * from multi_alter_pk_ok;
drop table if exists multi_alter_pk_ok;

-- 34: REPLICATION ON. Multi-ALTER: DROP PRIMARY KEY, ADD PRIMARY KEY(b), DROP PRIMARY KEY
-- ha_repl result: HA constraint violation
evaluate '34. multi_alter_pk_err';
drop table if exists multi_alter_pk_err;
CREATE TABLE multi_alter_pk_err(a BIGINT PRIMARY KEY, b VARCHAR(20), c INT)REPLICATION ON;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('multi_alter_pk_err') ORDER BY 1;
ALTER TABLE multi_alter_pk_err DROP PRIMARY KEY, ADD CONSTRAINT pk_multi_alter_pk_err_b PRIMARY KEY(b), DROP PRIMARY KEY;
SELECT class_name, index_name FROM db_index WHERE class_name IN ('multi_alter_pk_err') ORDER BY 1;
insert into multi_alter_pk_err values (1, 'test34', 1000);
insert into multi_alter_pk_err values (1, 'test34', 2000);
select * from multi_alter_pk_err;
drop table if exists multi_alter_pk_err;

