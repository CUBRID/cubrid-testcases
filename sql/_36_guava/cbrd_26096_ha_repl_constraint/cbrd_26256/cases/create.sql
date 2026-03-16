-- This test case verifies CBRD-26256 issue - CREATE TABLE with FK
-- Converted from ha_shell script to SQL test case format.
--
-- Scenario Overview:
-- This test verifies creating tables with foreign key constraints in CREATE TABLE statement.
-- Tests different combinations of replication settings for parent and child tables.

evaluate '1. CREATE TABLE with FK - REPLICATION OFF, CHILD REPLICATION OFF';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists create_b1_tbl;
drop table if exists create_a1_tbl;

CREATE TABLE create_a1_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION OFF;

CREATE TABLE create_b1_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES create_a1_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION OFF;

insert into create_a1_tbl values (1, '0101111222');
insert into create_a1_tbl values (2, '0103333444');
insert into create_b1_tbl values (1, 'alice');
insert into create_b1_tbl values (2, 'bob');

select * from create_a1_tbl order by 1,2;
select * from create_b1_tbl order by 1,2;

drop table if exists create_b1_tbl;
drop table if exists create_a1_tbl;

evaluate '2. CREATE TABLE with FK - REPLICATION ON, CHILD REPLICATION OFF';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists create_b2_tbl;
drop table if exists create_a2_tbl;

CREATE TABLE create_a2_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION ON;

CREATE TABLE create_b2_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES create_a2_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION OFF;

insert into create_a2_tbl values (1, '0101111222');
insert into create_a2_tbl values (2, '0103333444');
insert into create_b2_tbl values (1, 'alice');
insert into create_b2_tbl values (2, 'bob');

select * from create_a2_tbl order by 1,2;
select * from create_b2_tbl order by 1,2;

drop table if exists create_b2_tbl;
drop table if exists create_a2_tbl;

evaluate '3. CREATE TABLE with FK - REPLICATION ON, CHILD REPLICATION ON';
-- Test creating table with foreign key constraint in CREATE TABLE statement (should work)
drop table if exists create_b3_tbl;
drop table if exists create_a3_tbl;

CREATE TABLE create_a3_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION ON;

CREATE TABLE create_b3_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES create_a3_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION ON;


insert into create_a3_tbl values (1, '0101111222');
insert into create_a3_tbl values (2, '0103333444');
insert into create_b3_tbl values (1, 'alice');
insert into create_b3_tbl values (2, 'bob');

select * from create_a3_tbl order by 1,2;
select * from create_b3_tbl order by 1,2;

drop table if exists create_b3_tbl;
drop table if exists create_a3_tbl;

evaluate '4. CREATE TABLE with FK - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists create_b4_tbl;
drop table if exists create_a4_tbl;

CREATE TABLE create_a4_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION OFF;

CREATE TABLE create_b4_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES create_a4_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION ON;

insert into create_a4_tbl values (1, '0101111222');
insert into create_a4_tbl values (2, '0103333444');
insert into create_b4_tbl values (1, 'alice');
insert into create_b4_tbl values (2, 'bob');

select * from create_a4_tbl order by 1,2;
select * from create_b4_tbl order by 1,2;

drop table if exists create_b4_tbl;
drop table if exists create_a4_tbl;
