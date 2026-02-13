-- ============================================
-- SCHEMA & METADATA TESTS - INVISIBLE COLUMN
-- SHOW / DESC / INFORMATION SCHEMA / VIEW / TRIGGER
-- ============================================

-- ============================================
-- [1] SHOW & DESC STATEMENTS
-- ============================================

drop table if exists t1;

create table t1 (
    id int auto_increment invisible primary key,
    c1 int invisible,
    c2 int,
    c3 varchar(50) invisible,
    c4 int,
    index idx_c1 (c1),
    index idx_c2_c4 (c2, c4)
);

-- SHOW CREATE TABLE: should show INVISIBLE attribute
show create table t1;

-- SHOW COLUMNS: Extra show INVISIBLE info
show columns from t1;

-- SHOW INDEX: should show all indexes including on invisible columns
show index from t1;

-- DESC
desc t1;


-- ============================================
-- [2] INFORMATION SCHEMA / SYSTEM CATALOG
-- ============================================

-- query system catalog for invisible columns
select attr_name, is_nullable, default_value, is_invisible
from db_attribute
where class_name = 't1'
order by def_order;

-- detailed attribute info
select attr_name, data_type, prec, is_nullable, is_invisible
from db_attribute
where class_name = 't1'
order by def_order;

-- internal catalog flags
select attr_name, from_class_of, from_attr_name, flags
from _db_attribute
where class_of.class_name = 't1'
order by attr_name;

drop table if exists t1;


-- ============================================
-- [3] VIEW WITH INVISIBLE COLUMNS
-- ============================================

drop view if exists tbl_all_v;
drop view if exists tbl_v;
drop table if exists tbl;

create table tbl (
    c1 int auto_increment invisible primary key,
    c2 int visible not null,
    c3 int invisible default 3,
    c4 int,
    c5 varchar(32)
);

insert into tbl(c2, c4, c5) values (2, 4, '5');
insert into tbl(c2, c5) values (12, '15');
insert into tbl(c2, c5) values (22, '25'), (32, '35');

-- view based on SELECT * (no invisible columns)
create view tbl_v as select * from tbl;

-- err: c1 is invisible and not in view
/* err */ select * from tbl_v order by c1;
select * from tbl_v order by c4;

show create view tbl_v;

-- view with all columns including invisible
create view tbl_all_v as select c1, c2, c3, c4, c5 from tbl;
select * from tbl_all_v order by c1;


-- change visibility and check view behavior
alter table tbl modify column c1 int visible;
alter table tbl modify column c4 int invisible;

-- err: c1 still in view but now visible, c4 now invisible
/* err */ select * from tbl_v order by c1;
select * from tbl_all_v order by c1;


-- ALTER VIEW
alter view tbl_v add query select * from tbl;
show create view tbl_v;
/* tbl_v column count unchanged, new query still returns 3 cols */
select * from tbl_v;

alter view tbl_v as select * from tbl;
show create view tbl_v;
select * from tbl_v order by c1;

desc tbl;

-- restore c4 visible
alter table tbl modify column c4 int visible;
desc tbl;

drop view if exists tbl_all_v;
drop view if exists tbl_v;
drop table if exists tbl;


-- ============================================
-- [4] TRIGGER WITH INVISIBLE COLUMNS
-- ============================================

drop table if exists tbl;

create table tbl (
    c1 int auto_increment invisible primary key,
    c2 int visible not null,
    c3 int invisible default 3,
    c4 int,
    c5 varchar(32)
);

-- trigger that rejects if c4 is null (invisible column in condition)
create trigger tbl_c4_trigger before insert on tbl
    if new.c4 is null execute reject;

select trigger_name, target_attr_name, target_attr_type from db_trigger;

-- err: c4 is null, trigger rejects
/* err */ insert into tbl(c1, c2, c5) values (default, 99, 'c4 is null. reject');

-- ok: c4 is provided
insert into tbl(c2, c4, c5) values (22, 24, '25');

update statistics on tbl;

select /*+recompile*/ * from tbl where c1 = 2;
show trace;
select /*+recompile*/ c1, c2 from tbl where c1 is not null order by 1;
show trace;

drop table if exists tbl;
