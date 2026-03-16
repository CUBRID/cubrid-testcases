-- This test case verifies CBRD-26256 issue - Complex FK constraints
-- Converted from ha_shell script to SQL test case format.
--
-- Scenario Overview:
-- This test verifies complex foreign key constraints with different replication settings.
-- Tests include multiple FK constraints and composite key scenarios.

evaluate '1. Complex FK - Multiple FK constraints';
-- Test multiple foreign key constraints with different replication settings

evaluate '1-1. Referenced table (REPLICATION ON) <- FK table (REPLICATION ON)';
-- Test Case 1-1: Referenced table (REPLICATION ON) <- FK table (REPLICATION ON) - OK
drop table if exists complex_b1_1_tbl;
drop table if exists complex_c1_1_tbl;
drop table if exists complex_a1_1_tbl;

CREATE TABLE complex_a1_1_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION ON;

CREATE TABLE complex_c1_1_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    dept varchar(10)
)REPLICATION ON;

CREATE TABLE complex_b1_1_tbl (
    id INT NOT NULL PRIMARY KEY,
    a_id INT NOT NULL,
    c_id INT NOT NULL,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_a FOREIGN KEY (a_id) REFERENCES complex_a1_1_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk_c FOREIGN KEY (c_id) REFERENCES complex_c1_1_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION ON;

insert into complex_a1_1_tbl values (1, '0101111222');
insert into complex_a1_1_tbl values (2, '0103333444');
insert into complex_c1_1_tbl values (1, 'dev');
insert into complex_c1_1_tbl values (2, 'qa');
insert into complex_b1_1_tbl values (1, 1, 1, 'alice');
insert into complex_b1_1_tbl values (2, 2, 2, 'bob');

select * from complex_a1_1_tbl order by id;
select * from complex_c1_1_tbl order by id;
select * from complex_b1_1_tbl order by id;

select b.id, b.name, a.phone, c.dept 
from complex_b1_1_tbl b
join complex_a1_1_tbl a on b.a_id = a.id
join complex_c1_1_tbl c on b.c_id = c.id
order by b.id;

drop table if exists complex_b1_1_tbl;
drop table if exists complex_c1_1_tbl;
drop table if exists complex_a1_1_tbl;

evaluate '1-2. Referenced table (REPLICATION ON) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists complex_b1_2_tbl;
drop table if exists complex_c1_2_tbl;
drop table if exists complex_a1_2_tbl;

CREATE TABLE complex_a1_2_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION ON;

CREATE TABLE complex_c1_2_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    dept varchar(10)
)REPLICATION ON;

CREATE TABLE complex_b1_2_tbl (
    id INT NOT NULL PRIMARY KEY,
    a_id INT NOT NULL,
    c_id INT NOT NULL,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_a FOREIGN KEY (a_id) REFERENCES complex_a1_2_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk_c FOREIGN KEY (c_id) REFERENCES complex_c1_2_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION OFF;

insert into complex_a1_2_tbl values (1, '0101111222');
insert into complex_a1_2_tbl values (2, '0103333444');
insert into complex_c1_2_tbl values (1, 'dev');
insert into complex_c1_2_tbl values (2, 'qa');
insert into complex_b1_2_tbl values (1, 1, 1, 'alice');
insert into complex_b1_2_tbl values (2, 2, 2, 'bob');

select * from complex_a1_2_tbl order by id;
select * from complex_c1_2_tbl order by id;
select * from complex_b1_2_tbl order by id;

select b.id, b.name, a.phone, c.dept 
from complex_b1_2_tbl b
join complex_a1_2_tbl a on b.a_id = a.id
join complex_c1_2_tbl c on b.c_id = c.id
order by b.id;

drop table if exists complex_b1_2_tbl;
drop table if exists complex_c1_2_tbl;
drop table if exists complex_a1_2_tbl;

evaluate '1-3. Referenced table (REPLICATION OFF) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists complex_b1_3_tbl;
drop table if exists complex_c1_3_tbl;
drop table if exists complex_a1_3_tbl;

CREATE TABLE complex_a1_3_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION OFF;

CREATE TABLE complex_c1_3_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    dept varchar(10)
)REPLICATION OFF;

CREATE TABLE complex_b1_3_tbl (
    id INT NOT NULL PRIMARY KEY,
    a_id INT NOT NULL,
    c_id INT NOT NULL,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_a FOREIGN KEY (a_id) REFERENCES complex_a1_3_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk_c FOREIGN KEY (c_id) REFERENCES complex_c1_3_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION OFF;

insert into complex_a1_3_tbl values (1, '0101111222');
insert into complex_a1_3_tbl values (2, '0103333444');
insert into complex_c1_3_tbl values (1, 'dev');
insert into complex_c1_3_tbl values (2, 'qa');
insert into complex_b1_3_tbl values (1, 1, 1, 'alice');
insert into complex_b1_3_tbl values (2, 2, 2, 'bob');

select * from complex_a1_3_tbl order by id;
select * from complex_c1_3_tbl order by id;
select * from complex_b1_3_tbl order by id;

select b.id, b.name, a.phone, c.dept 
from complex_b1_3_tbl b
join complex_a1_3_tbl a on b.a_id = a.id
join complex_c1_3_tbl c on b.c_id = c.id
order by b.id;

drop table if exists complex_b1_3_tbl;
drop table if exists complex_c1_3_tbl;
drop table if exists complex_a1_3_tbl;

evaluate '1-4. Complex FK - Multiple FK constraints - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists complex_b1_4_tbl;
drop table if exists complex_c1_4_tbl;
drop table if exists complex_a1_4_tbl;

CREATE TABLE complex_a1_4_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    phone VARCHAR(10)
)REPLICATION OFF;

CREATE TABLE complex_c1_4_tbl (
    id INT NOT NULL DEFAULT 0 PRIMARY KEY,
    dept varchar(10)
)REPLICATION OFF;

CREATE TABLE complex_b1_4_tbl (
    id INT NOT NULL PRIMARY KEY,
    a_id INT NOT NULL,
    c_id INT NOT NULL,
    name VARCHAR (10) NOT NULL,
    CONSTRAINT fk_a FOREIGN KEY (a_id) REFERENCES complex_a1_4_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT fk_c FOREIGN KEY (c_id) REFERENCES complex_c1_4_tbl (id)
    ON DELETE CASCADE ON UPDATE RESTRICT
)REPLICATION ON;

insert into complex_a1_4_tbl values (1, '0101111222');
insert into complex_a1_4_tbl values (2, '0103333444');
insert into complex_c1_4_tbl values (1, 'dev');
insert into complex_c1_4_tbl values (2, 'qa');
insert into complex_b1_4_tbl values (1, 1, 1, 'alice');
insert into complex_b1_4_tbl values (2, 2, 2, 'bob');

select * from complex_a1_4_tbl order by id;
select * from complex_c1_4_tbl order by id;
select * from complex_b1_4_tbl order by id;

select b.id, b.name, a.phone, c.dept 
from complex_b1_4_tbl b
join complex_a1_4_tbl a on b.a_id = a.id
join complex_c1_4_tbl c on b.c_id = c.id
order by b.id;

drop table if exists complex_b1_4_tbl;
drop table if exists complex_c1_4_tbl;
drop table if exists complex_a1_4_tbl;

evaluate '2. Complex FK - Composite key';
-- Test foreign key constraints with composite primary keys

evaluate '2-1. Referenced table (REPLICATION ON) <- FK table (REPLICATION ON)';
-- Test Case 2-1: Referenced table (REPLICATION ON) <- FK table (REPLICATION ON) - OK
drop table if exists complex_b2_1_tbl;
drop table if exists complex_a2_1_tbl;

create table complex_a2_1_tbl (
    id1 int not null default 0,
    id2 int not null default 0,
    phone varchar(10),
    constraint pk_a primary key (id1, id2)
)REPLICATION ON;

create table complex_b2_1_tbl (
    id    int not null primary key,
    a_id1 int not null,
    a_id2 int not null,
    name  varchar(10) not null,
    constraint fk_a foreign key (a_id1, a_id2) references complex_a2_1_tbl (id1, id2)
        on delete cascade on update restrict
)REPLICATION ON;

insert into complex_a2_1_tbl values (1, 10, '0101111222');
insert into complex_a2_1_tbl values (2, 20, '0103333444');
insert into complex_b2_1_tbl values (1, 1, 10, 'alice');
insert into complex_b2_1_tbl values (2, 2, 20, 'bob');

select * from complex_a2_1_tbl order by 1,2;
select * from complex_b2_1_tbl order by 1,2;

drop table if exists complex_b2_1_tbl;
drop table if exists complex_a2_1_tbl;

evaluate '2-2. Referenced table (REPLICATION ON) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists complex_b2_2_tbl;
drop table if exists complex_a2_2_tbl;

create table complex_a2_2_tbl (
    id1 int not null default 0,
    id2 int not null default 0,
    phone varchar(10),
    constraint pk_a primary key (id1, id2)
)REPLICATION ON;

create table complex_b2_2_tbl (
    id    int not null primary key,
    a_id1 int not null,
    a_id2 int not null,
    name  varchar(10) not null,
    constraint fk_a foreign key (a_id1, a_id2) references complex_a2_2_tbl (id1, id2)
        on delete cascade on update restrict
)REPLICATION OFF;

insert into complex_a2_2_tbl values (1, 10, '0101111222');
insert into complex_a2_2_tbl values (2, 20, '0103333444');
insert into complex_b2_2_tbl values (1, 1, 10, 'alice');
insert into complex_b2_2_tbl values (2, 2, 20, 'bob');

select * from complex_a2_2_tbl order by 1,2;
select * from complex_b2_2_tbl order by 1,2;

drop table if exists complex_b2_2_tbl;
drop table if exists complex_a2_2_tbl;

evaluate '2-3. Referenced table (REPLICATION OFF) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists complex_b2_3_tbl;
drop table if exists complex_a2_3_tbl;

create table complex_a2_3_tbl (
    id1 int not null default 0,
    id2 int not null default 0,
    phone varchar(10),
    constraint pk_a primary key (id1, id2)
)REPLICATION OFF;

create table complex_b2_3_tbl (
    id    int not null primary key,
    a_id1 int not null,
    a_id2 int not null,
    name  varchar(10) not null,
    constraint fk_a foreign key (a_id1, a_id2) references complex_a2_3_tbl (id1, id2)
        on delete cascade on update restrict
)REPLICATION OFF;

insert into complex_a2_3_tbl values (1, 10, '0101111222');
insert into complex_a2_3_tbl values (2, 20, '0103333444');
insert into complex_b2_3_tbl values (1, 1, 10, 'alice');
insert into complex_b2_3_tbl values (2, 2, 20, 'bob');

select * from complex_a2_3_tbl order by 1,2;
select * from complex_b2_3_tbl order by 1,2;

drop table if exists complex_b2_3_tbl;
drop table if exists complex_a2_3_tbl;

evaluate '2-4. Complex FK - Composite key - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists complex_b2_4_tbl;
drop table if exists complex_a2_4_tbl;

create table complex_a2_4_tbl (
    id1 int not null default 0,
    id2 int not null default 0,
    phone varchar(10),
    constraint pk_a primary key (id1, id2)
)REPLICATION OFF;

create table complex_b2_4_tbl (
    id    int not null primary key,
    a_id1 int not null,
    a_id2 int not null,
    name  varchar(10) not null,
    constraint fk_a foreign key (a_id1, a_id2) references complex_a2_4_tbl (id1, id2)
        on delete cascade on update restrict
)REPLICATION ON;

insert into complex_a2_4_tbl values (1, 10, '0101111222');
insert into complex_a2_4_tbl values (2, 20, '0103333444');
insert into complex_b2_4_tbl values (1, 1, 10, 'alice');
insert into complex_b2_4_tbl values (2, 2, 20, 'bob');

select * from complex_a2_4_tbl order by 1,2;
select * from complex_b2_4_tbl order by 1,2;

drop table if exists complex_b2_4_tbl;
drop table if exists complex_a2_4_tbl;

evaluate '3. Complex FK - NULL and without PK constraints';
-- Due to current CTP limitation, when REPLICATION option is explicitly specified,
-- PRIMARY KEY is not created unless the entire CREATE TABLE statement is written in a single line.
-- This scenario group verifies FK behavior when NOT NULL and PRIMARY KEY constraints are removed or relaxed under this limitation.

evaluate '3-1. Referenced table (PK) <- FK table (NULL allowed, no PK)';
-- Test FK with referenced table having PK, FK table without NOT NULL and PK.
-- Data are inserted successfully on both master and slave.
drop table if exists complex_b3_1_tbl;
drop table if exists complex_a3_1_tbl;

CREATE TABLE complex_a3_1_tbl ( id INT PRIMARY KEY, phone VARCHAR(10) )REPLICATION ON;

CREATE TABLE complex_b3_1_tbl ( id INT, a_id INT, name VARCHAR (10), CONSTRAINT fk_a FOREIGN KEY (a_id) REFERENCES complex_a3_1_tbl (id) ON DELETE CASCADE ON UPDATE RESTRICT )REPLICATION ON;

insert into complex_a3_1_tbl values (1, '0101111222');
insert into complex_a3_1_tbl values (2, '0103333444');
insert into complex_a3_1_tbl values (3, NULL);
insert into complex_a3_1_tbl values (NULL, '0109999999');
insert into complex_b3_1_tbl values (1, 1, 'alice');
insert into complex_b3_1_tbl values (2, 2, 'bob');
insert into complex_b3_1_tbl values (3, NULL, 'charlie');
insert into complex_b3_1_tbl values (NULL, 1, 'david');
insert into complex_b3_1_tbl values (NULL, 3, NULL);

select * from complex_a3_1_tbl order by id;
select * from complex_b3_1_tbl order by id;

select b.id, b.name, a.phone 
from complex_b3_1_tbl b
left join complex_a3_1_tbl a on b.a_id = a.id
order by b.id;

drop table if exists complex_b3_1_tbl;
drop table if exists complex_a3_1_tbl;

evaluate '3-2. Referenced table (NULL allowed, no PK) <- FK table (NOT NULL, PK)';
-- Test FK with referenced table without NOT NULL and PK, FK table with NOT NULL and PK.
-- In ha_repl, neither master nor slave creates complex_a3_2_tbl, so complex_b3_2_tbl is also not created.
drop table if exists complex_b3_2_tbl;
drop table if exists complex_a3_2_tbl;

CREATE TABLE complex_a3_2_tbl ( id INT, phone VARCHAR(10) )REPLICATION ON;

CREATE TABLE complex_b3_2_tbl ( id INT NOT NULL PRIMARY KEY, a_id INT NOT NULL, name VARCHAR (10), CONSTRAINT fk_a FOREIGN KEY (a_id) REFERENCES complex_a3_2_tbl (id) ON DELETE CASCADE ON UPDATE RESTRICT )REPLICATION ON;

insert into complex_a3_2_tbl values (1, '0101111222');
insert into complex_a3_2_tbl values (2, '0103333444');
insert into complex_a3_2_tbl values (NULL, '0109999999');

select * from complex_a3_2_tbl order by id;

drop table if exists complex_b3_2_tbl;
drop table if exists complex_a3_2_tbl;

evaluate '3-3. Referenced table (NULL allowed, no PK) <- FK table (NULL allowed, no PK)';
-- Test FK with both referenced and FK tables without NOT NULL and PK.
-- In ha_repl, neither master nor slave creates complex_a3_3_tbl, so complex_b3_3_tbl is also not created.
drop table if exists complex_b3_3_tbl;
drop table if exists complex_a3_3_tbl;

CREATE TABLE complex_a3_3_tbl ( id INT, phone VARCHAR(10) )REPLICATION ON;

CREATE TABLE complex_b3_3_tbl ( id INT, a_id INT, name VARCHAR (10), CONSTRAINT fk_a FOREIGN KEY (a_id) REFERENCES complex_a3_3_tbl (id) ON DELETE CASCADE ON UPDATE RESTRICT )REPLICATION ON;

insert into complex_a3_3_tbl values (1, '0101111222');
insert into complex_a3_3_tbl values (2, '0103333444');
insert into complex_a3_3_tbl values (NULL, '0109999999');

select * from complex_a3_3_tbl order by id;

drop table if exists complex_b3_3_tbl;
drop table if exists complex_a3_3_tbl;
