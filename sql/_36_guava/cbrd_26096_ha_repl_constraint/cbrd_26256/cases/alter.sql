-- This test case verifies CBRD-26256 issue - ALTER TABLE with FK
-- Converted from ha_shell script to SQL test case format.
--
-- Scenario Overview:
-- This test verifies adding foreign key constraints using ALTER TABLE statement.
-- Tests different combinations of replication settings for parent and child tables.

evaluate '1. ALTER TABLE with FK - REPLICATION OFF, CHILD REPLICATION OFF';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists alter_b1_tbl;
drop table if exists alter_a1_tbl;

CREATE TABLE alter_a1_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION OFF;

CREATE TABLE alter_b1_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL
)REPLICATION OFF;

ALTER TABLE alter_b1_tbl ADD CONSTRAINT FOREIGN KEY(id) REFERENCES alter_a1_tbl(id);
insert into alter_a1_tbl values (1, '0101111222');
insert into alter_a1_tbl values (2, '0103333444');
insert into alter_b1_tbl values (1, 'alice');
insert into alter_b1_tbl values (2, 'bob');

select * from alter_a1_tbl order by 1,2;
select * from alter_b1_tbl order by 1,2;

drop table if exists alter_b1_tbl;
drop table if exists alter_a1_tbl;

evaluate '2. ALTER TABLE with FK - REPLICATION ON, CHILD REPLICATION OFF';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists alter_b2_tbl;
drop table if exists alter_a2_tbl;

CREATE TABLE alter_a2_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION ON;

CREATE TABLE alter_b2_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL
)REPLICATION OFF;

ALTER TABLE alter_b2_tbl ADD CONSTRAINT FOREIGN KEY(id) REFERENCES alter_a2_tbl(id);
insert into alter_a2_tbl values (1, '0101111222');
insert into alter_a2_tbl values (2, '0103333444');
insert into alter_b2_tbl values (1, 'alice');
insert into alter_b2_tbl values (2, 'bob');

select * from alter_a2_tbl order by 1,2;
select * from alter_b2_tbl order by 1,2;

drop table if exists alter_b2_tbl;
drop table if exists alter_a2_tbl;

evaluate '3. ALTER TABLE with FK - REPLICATION ON, CHILD REPLICATION ON';
-- Test adding foreign key constraint using ALTER TABLE (should work)
drop table if exists alter_b3_tbl;
drop table if exists alter_a3_tbl;

CREATE TABLE alter_a3_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION ON;

CREATE TABLE alter_b3_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL
)REPLICATION ON;

ALTER TABLE alter_b3_tbl ADD CONSTRAINT FOREIGN KEY(id) REFERENCES alter_a3_tbl(id);
insert into alter_a3_tbl values (1, '0101111222');
insert into alter_a3_tbl values (2, '0103333444');
insert into alter_b3_tbl values (1, 'alice');
insert into alter_b3_tbl values (2, 'bob');

select * from alter_a3_tbl order by 1,2;
select * from alter_b3_tbl order by 1,2;

drop table if exists alter_b3_tbl;
drop table if exists alter_a3_tbl;

evaluate '4. ALTER TABLE with FK - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists alter_b4_tbl;
drop table if exists alter_a4_tbl;

CREATE TABLE alter_a4_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION OFF;

CREATE TABLE alter_b4_tbl (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR (10) NOT NULL
)REPLICATION ON;

ALTER TABLE alter_b4_tbl ADD CONSTRAINT FOREIGN KEY(id) REFERENCES alter_a4_tbl(id);

insert into alter_a4_tbl values (1, '0101111222');
insert into alter_a4_tbl values (2, '0103333444');
insert into alter_b4_tbl values (1, 'alice');
insert into alter_b4_tbl values (2, 'bob');

select * from alter_a4_tbl order by 1,2;
select * from alter_b4_tbl order by 1,2;

drop table if exists alter_b4_tbl;
drop table if exists alter_a4_tbl;
