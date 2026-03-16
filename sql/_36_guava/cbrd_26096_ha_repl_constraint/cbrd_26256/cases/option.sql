-- This test case verifies CBRD-26256 issue - FK Option (ON DELETE/ON UPDATE)
-- Converted from ha_shell script to SQL test case format.
--
-- Scenario Overview:
-- This test verifies foreign key constraint options (ON DELETE/ON UPDATE) with different replication settings.
-- Tests various combinations of CASCADE, NO ACTION, RESTRICT, and SET NULL options.

evaluate '1. FK Option - ON DELETE CASCADE ON UPDATE NO ACTION';
-- Test foreign key with CASCADE delete and NO ACTION update options

evaluate '1-1. Referenced table (REPLICATION ON) <- FK table (REPLICATION ON)';
-- Test Case 1-1: Referenced table (REPLICATION ON) <- FK table (REPLICATION ON) - OK
drop table if exists option_b1_1_tbl;
drop table if exists option_a1_1_tbl;

create table option_a1_1_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b1_1_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a1_1_tbl (id)
        on delete cascade
        on update no action
) REPLICATION ON;

insert into option_a1_1_tbl values (1, '0101111222');
insert into option_a1_1_tbl values (2, '0103333444');
insert into option_a1_1_tbl values (3, '0105555666');

insert into option_b1_1_tbl values (1, 'alice');
insert into option_b1_1_tbl values (2, 'bob');
insert into option_b1_1_tbl values (3, 'charlie');

delete from option_a1_1_tbl where id = 1;
update option_a1_1_tbl set id = 10 where id = 2;

select * from option_a1_1_tbl order by 1,2;
select * from option_b1_1_tbl order by 1,2;

drop table if exists option_b1_1_tbl;
drop table if exists option_a1_1_tbl;

evaluate '1-2. Referenced table (REPLICATION ON) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b1_2_tbl;
drop table if exists option_a1_2_tbl;

create table option_a1_2_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b1_2_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a1_2_tbl (id)
        on delete cascade
        on update no action
) REPLICATION OFF;

insert into option_a1_2_tbl values (1, '0101111222');
insert into option_a1_2_tbl values (2, '0103333444');
insert into option_a1_2_tbl values (3, '0105555666');

insert into option_b1_2_tbl values (1, 'alice');
insert into option_b1_2_tbl values (2, 'bob');
insert into option_b1_2_tbl values (3, 'charlie');

delete from option_a1_2_tbl where id = 1;
update option_a1_2_tbl set id = 10 where id = 2;

select * from option_a1_2_tbl order by 1,2;
select * from option_b1_2_tbl order by 1,2;

drop table if exists option_b1_2_tbl;
drop table if exists option_a1_2_tbl;

evaluate '1-3. Referenced table (REPLICATION OFF) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b1_3_tbl;
drop table if exists option_a1_3_tbl;

create table option_a1_3_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b1_3_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a1_3_tbl (id)
        on delete cascade
        on update no action
) REPLICATION OFF;

insert into option_a1_3_tbl values (1, '0101111222');
insert into option_a1_3_tbl values (2, '0103333444');
insert into option_a1_3_tbl values (3, '0105555666');

insert into option_b1_3_tbl values (1, 'alice');
insert into option_b1_3_tbl values (2, 'bob');
insert into option_b1_3_tbl values (3, 'charlie');

delete from option_a1_3_tbl where id = 1;
update option_a1_3_tbl set id = 10 where id = 2;

select * from option_a1_3_tbl order by 1,2;
select * from option_b1_3_tbl order by 1,2;

drop table if exists option_b1_3_tbl;
drop table if exists option_a1_3_tbl;

evaluate '1-4. FK Option - ON DELETE CASCADE ON UPDATE NO ACTION - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists option_b1_4_tbl;
drop table if exists option_a1_4_tbl;

create table option_a1_4_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b1_4_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a1_4_tbl (id)
        on delete cascade
        on update no action
) REPLICATION ON;

insert into option_a1_4_tbl values (1, '0101111222');
insert into option_a1_4_tbl values (2, '0103333444');
insert into option_a1_4_tbl values (3, '0105555666');

insert into option_b1_4_tbl values (1, 'alice');
insert into option_b1_4_tbl values (2, 'bob');
insert into option_b1_4_tbl values (3, 'charlie');

delete from option_a1_4_tbl where id = 1;
update option_a1_4_tbl set id = 10 where id = 2;

select * from option_a1_4_tbl order by 1,2;
select * from option_b1_4_tbl order by 1,2;

drop table if exists option_b1_4_tbl;
drop table if exists option_a1_4_tbl;

evaluate '2. FK Option - ON DELETE NO ACTION ON UPDATE SET NULL';
-- Test foreign key with NO ACTION delete and SET NULL update options

evaluate '2-1. Referenced table (REPLICATION ON) <- FK table (REPLICATION ON)';
-- Test Case 2-1: Referenced table (REPLICATION ON) <- FK table (REPLICATION ON) - OK
drop table if exists option_b2_1_tbl;
drop table if exists option_a2_1_tbl;

create table option_a2_1_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b2_1_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a2_1_tbl (id)
        on delete no action
        on update set null
) REPLICATION ON;

insert into option_a2_1_tbl values (1, '0101111222');
insert into option_a2_1_tbl values (2, '0103333444');
insert into option_a2_1_tbl values (3, '0105555666');

insert into option_b2_1_tbl values (1, 1, 'alice');
insert into option_b2_1_tbl values (2, 2, 'bob');
insert into option_b2_1_tbl values (3, 3, 'charlie');

delete from option_a2_1_tbl where id = 1;
update option_a2_1_tbl set id = 10 where id = 2;

select * from option_a2_1_tbl order by 1,2;
select * from option_b2_1_tbl order by 1,2;

drop table if exists option_b2_1_tbl;
drop table if exists option_a2_1_tbl;

evaluate '2-2. Referenced table (REPLICATION ON) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b2_2_tbl;
drop table if exists option_a2_2_tbl;

create table option_a2_2_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b2_2_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a2_2_tbl (id)
        on delete no action
        on update set null
) REPLICATION OFF;

insert into option_a2_2_tbl values (1, '0101111222');
insert into option_a2_2_tbl values (2, '0103333444');
insert into option_a2_2_tbl values (3, '0105555666');

insert into option_b2_2_tbl values (1, 1, 'alice');
insert into option_b2_2_tbl values (2, 2, 'bob');
insert into option_b2_2_tbl values (3, 3, 'charlie');

delete from option_a2_2_tbl where id = 1;
update option_a2_2_tbl set id = 10 where id = 2;

select * from option_a2_2_tbl order by 1,2;
select * from option_b2_2_tbl order by 1,2;

drop table if exists option_b2_2_tbl;
drop table if exists option_a2_2_tbl;

evaluate '2-3. Referenced table (REPLICATION OFF) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b2_3_tbl;
drop table if exists option_a2_3_tbl;

create table option_a2_3_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b2_3_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a2_3_tbl (id)
        on delete no action
        on update set null
) REPLICATION OFF;

insert into option_a2_3_tbl values (1, '0101111222');
insert into option_a2_3_tbl values (2, '0103333444');
insert into option_a2_3_tbl values (3, '0105555666');

insert into option_b2_3_tbl values (1, 1, 'alice');
insert into option_b2_3_tbl values (2, 2, 'bob');
insert into option_b2_3_tbl values (3, 3, 'charlie');

delete from option_a2_3_tbl where id = 1;
update option_a2_3_tbl set id = 10 where id = 2;

select * from option_a2_3_tbl order by 1,2;
select * from option_b2_3_tbl order by 1,2;

drop table if exists option_b2_3_tbl;
drop table if exists option_a2_3_tbl;

evaluate '2-4. FK Option - ON DELETE NO ACTION ON UPDATE SET NULL - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists option_b2_4_tbl;
drop table if exists option_a2_4_tbl;

create table option_a2_4_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b2_4_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a2_4_tbl (id)
        on delete no action
        on update set null
) REPLICATION ON;

insert into option_a2_4_tbl values (1, '0101111222');
insert into option_a2_4_tbl values (2, '0103333444');
insert into option_a2_4_tbl values (3, '0105555666');

insert into option_b2_4_tbl values (1, 1, 'alice');
insert into option_b2_4_tbl values (2, 2, 'bob');
insert into option_b2_4_tbl values (3, 3, 'charlie');

delete from option_a2_4_tbl where id = 1;
update option_a2_4_tbl set id = 10 where id = 2;

select * from option_a2_4_tbl order by 1,2;
select * from option_b2_4_tbl order by 1,2;

drop table if exists option_b2_4_tbl;
drop table if exists option_a2_4_tbl;

evaluate '3. FK Option - ON DELETE RESTRICT ON UPDATE RESTRICT';
-- Test foreign key with RESTRICT delete and RESTRICT update options

evaluate '3-1. Referenced table (REPLICATION ON) <- FK table (REPLICATION ON)';
-- Test Case 3-1: Referenced table (REPLICATION ON) <- FK table (REPLICATION ON) - OK
drop table if exists option_b3_1_tbl;
drop table if exists option_a3_1_tbl;

create table option_a3_1_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b3_1_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a3_1_tbl (id)
        on delete restrict
        on update restrict
) REPLICATION ON;

insert into option_a3_1_tbl values (1, '0101111222');
insert into option_a3_1_tbl values (2, '0103333444');
insert into option_a3_1_tbl values (3, '0105555666');

insert into option_b3_1_tbl values (1, 'alice');
insert into option_b3_1_tbl values (2, 'bob');
insert into option_b3_1_tbl values (3, 'charlie');

-- Expected error (RESTRICT)
delete from option_a3_1_tbl where id = 1; 
-- Expected error (RESTRICT)
update option_a3_1_tbl set id = 10 where id = 2; 

select * from option_a3_1_tbl order by 1,2;
select * from option_b3_1_tbl order by 1,2;

drop table if exists option_b3_1_tbl;
drop table if exists option_a3_1_tbl;

evaluate '3-2. Referenced table (REPLICATION ON) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b3_2_tbl;
drop table if exists option_a3_2_tbl;

create table option_a3_2_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b3_2_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a3_2_tbl (id)
        on delete restrict
        on update restrict
) REPLICATION OFF;

insert into option_a3_2_tbl values (1, '0101111222');
insert into option_a3_2_tbl values (2, '0103333444');
insert into option_a3_2_tbl values (3, '0105555666');

insert into option_b3_2_tbl values (1, 'alice');
insert into option_b3_2_tbl values (2, 'bob');
insert into option_b3_2_tbl values (3, 'charlie');

-- Expected error (RESTRICT)
delete from option_a3_2_tbl where id = 1; 
-- Expected error (RESTRICT)
update option_a3_2_tbl set id = 10 where id = 2; 

select * from option_a3_2_tbl order by 1,2;
select * from option_b3_2_tbl order by 1,2;

drop table if exists option_b3_2_tbl;
drop table if exists option_a3_2_tbl;

evaluate '3-3. Referenced table (REPLICATION OFF) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b3_3_tbl;
drop table if exists option_a3_3_tbl;

create table option_a3_3_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b3_3_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a3_3_tbl (id)
        on delete restrict
        on update restrict
) REPLICATION OFF;

insert into option_a3_3_tbl values (1, '0101111222');
insert into option_a3_3_tbl values (2, '0103333444');
insert into option_a3_3_tbl values (3, '0105555666');

insert into option_b3_3_tbl values (1, 'alice');
insert into option_b3_3_tbl values (2, 'bob');
insert into option_b3_3_tbl values (3, 'charlie');

-- Expected error (RESTRICT)
delete from option_a3_3_tbl where id = 1; 
-- Expected error (RESTRICT)
update option_a3_3_tbl set id = 10 where id = 2; 

select * from option_a3_3_tbl order by 1,2;
select * from option_b3_3_tbl order by 1,2;

drop table if exists option_b3_3_tbl;
drop table if exists option_a3_3_tbl;

evaluate '3-4. FK Option - ON DELETE RESTRICT ON UPDATE RESTRICT - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists option_b3_4_tbl;
drop table if exists option_a3_4_tbl;

create table option_a3_4_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b3_4_tbl (
    id int not null primary key,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a3_4_tbl (id)
        on delete restrict
        on update restrict
) REPLICATION ON;

insert into option_a3_4_tbl values (1, '0101111222');
insert into option_a3_4_tbl values (2, '0103333444');
insert into option_a3_4_tbl values (3, '0105555666');

insert into option_b3_4_tbl values (1, 'alice');
insert into option_b3_4_tbl values (2, 'bob');
insert into option_b3_4_tbl values (3, 'charlie');

-- Expected error (RESTRICT)
delete from option_a3_4_tbl where id = 1; 
-- Expected error (RESTRICT)
update option_a3_4_tbl set id = 10 where id = 2; 

select * from option_a3_4_tbl order by 1,2;
select * from option_b3_4_tbl order by 1,2;

drop table if exists option_b3_4_tbl;
drop table if exists option_a3_4_tbl;

evaluate '4. FK Option - ON DELETE SET NULL ON UPDATE RESTRICT';
-- Test foreign key with SET NULL delete and RESTRICT update options

evaluate '4-1. Referenced table (REPLICATION ON) <- FK table (REPLICATION ON)';
-- Test Case 4-1: Referenced table (REPLICATION ON) <- FK table (REPLICATION ON) - OK
drop table if exists option_b4_1_tbl;
drop table if exists option_a4_1_tbl;

create table option_a4_1_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b4_1_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a4_1_tbl (id)
        on delete set null
        on update restrict
) REPLICATION ON;

insert into option_a4_1_tbl values (1, '0101111222');
insert into option_a4_1_tbl values (2, '0103333444');
insert into option_a4_1_tbl values (3, '0105555666');

insert into option_b4_1_tbl values (1, 1, 'alice');
insert into option_b4_1_tbl values (2, 2, 'bob');
insert into option_b4_1_tbl values (3, 3, 'charlie');

delete from option_a4_1_tbl where id = 1;
-- Expected error (RESTRICT)
update option_a4_1_tbl set id = 10 where id = 2; 

select * from option_a4_1_tbl order by 1,2;
select * from option_b4_1_tbl order by 1,2;

drop table if exists option_b4_1_tbl;
drop table if exists option_a4_1_tbl;

evaluate '4-2. Referenced table (REPLICATION ON) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b4_2_tbl;
drop table if exists option_a4_2_tbl;

create table option_a4_2_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION ON;

create table option_b4_2_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a4_2_tbl (id)
        on delete set null
        on update restrict
) REPLICATION OFF;

insert into option_a4_2_tbl values (1, '0101111222');
insert into option_a4_2_tbl values (2, '0103333444');
insert into option_a4_2_tbl values (3, '0105555666');

insert into option_b4_2_tbl values (1, 1, 'alice');
insert into option_b4_2_tbl values (2, 2, 'bob');
insert into option_b4_2_tbl values (3, 3, 'charlie');

delete from option_a4_2_tbl where id = 1;
-- Expected error (RESTRICT)
update option_a4_2_tbl set id = 10 where id = 2; 

select * from option_a4_2_tbl order by 1,2;
select * from option_b4_2_tbl order by 1,2;

drop table if exists option_b4_2_tbl;
drop table if exists option_a4_2_tbl;

evaluate '4-3. Referenced table (REPLICATION OFF) <- FK table (REPLICATION OFF)';
-- Master-slave data inconsistency is expected by design: REPLICATION OFF tables are not replicated in HA mode.
-- ha_repl tests will generate diff files for this case.
drop table if exists option_b4_3_tbl;
drop table if exists option_a4_3_tbl;

create table option_a4_3_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b4_3_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a4_3_tbl (id)
        on delete set null
        on update restrict
) REPLICATION OFF;

insert into option_a4_3_tbl values (1, '0101111222');
insert into option_a4_3_tbl values (2, '0103333444');
insert into option_a4_3_tbl values (3, '0105555666');

insert into option_b4_3_tbl values (1, 1, 'alice');
insert into option_b4_3_tbl values (2, 2, 'bob');
insert into option_b4_3_tbl values (3, 3, 'charlie');

delete from option_a4_3_tbl where id = 1;
-- Expected error (RESTRICT)
update option_a4_3_tbl set id = 10 where id = 2; 

select * from option_a4_3_tbl order by 1,2;
select * from option_b4_3_tbl order by 1,2;

drop table if exists option_b4_3_tbl;
drop table if exists option_a4_3_tbl;

evaluate '4-4. FK Option - ON DELETE SET NULL ON UPDATE RESTRICT - REPLICATION OFF, CHILD REPLICATION ON';
-- Single mode: OK. HA mode: ERROR - HA constraint violation (replication-enabled table cannot reference replication-OFF table).
drop table if exists option_b4_4_tbl;
drop table if exists option_a4_4_tbl;

create table option_a4_4_tbl (
    id int not null default 0 primary key,
    phone varchar(10)
) REPLICATION OFF;

create table option_b4_4_tbl (
    rid int not null primary key,
    id int null,
    name varchar(10) not null,
    constraint fk_id foreign key (id) references option_a4_4_tbl (id)
        on delete set null
        on update restrict
) REPLICATION ON;

insert into option_a4_4_tbl values (1, '0101111222');
insert into option_a4_4_tbl values (2, '0103333444');
insert into option_a4_4_tbl values (3, '0105555666');

insert into option_b4_4_tbl values (1, 1, 'alice');
insert into option_b4_4_tbl values (2, 2, 'bob');
insert into option_b4_4_tbl values (3, 3, 'charlie');

delete from option_a4_4_tbl where id = 1;
-- Expected error (RESTRICT)
update option_a4_4_tbl set id = 10 where id = 2;

select * from option_a4_4_tbl order by 1,2;
select * from option_b4_4_tbl order by 1,2;

drop table if exists option_b4_4_tbl;
drop table if exists option_a4_4_tbl;
