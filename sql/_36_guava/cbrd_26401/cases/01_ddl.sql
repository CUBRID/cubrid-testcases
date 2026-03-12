-- ============================================
-- DDL TESTS - INVISIBLE COLUMN
-- CREATE / ALTER / DROP / TRUNCATE / PARTITION
-- ============================================

-- ============================================
-- [1] CREATE TABLE TESTS
-- ============================================

drop table if exists tbl;

-- err: at least one visible column required
evaluate 'err: at least one visible column required';
/* err */ create table tbl (c1 int invisible);
evaluate 'err';
/* err */ create table tbl (c1 int invisible, c2 int invisible);


-- valid: mixed visible/invisible columns
evaluate 'valid: mixed visible/invisible columns';
create table tbl (
    c1 int auto_increment invisible primary key,
    c2 int visible not null,
    c3 int invisible default 3,
    c4 int,
    c5 varchar(32)
) partition by hash (c1) partitions 2;

show create table tbl;
desc tbl;

drop table if exists tbl;


-- ============================================
-- [2] ALTER TABLE TESTS
-- ============================================

create table tbl (c1 int);

-- err: only invisible column left after modify
evaluate 'err: only invisible column left after modify';
/* err */ alter table tbl modify column c1 int invisible;

alter table tbl add column c2 int invisible;
desc tbl;

-- err: cannot drop last visible column
evaluate 'err: cannot drop last visible column';
/* err */ alter table tbl drop column c1;

drop table if exists tbl;

create table tbl (
c1 int,
c2 int
);

insert into tbl values (1,2);

-- add invisible column after c1
evaluate 'add invisible column after c1';
alter table tbl add column c3 int invisible after c1;

-- verify column order via metadata
evaluate 'verify column order via metadata';
desc tbl;

-- verify column order via system catalog
evaluate 'verify column order via system catalog';
select attr_name, def_order from db_attribute where class_name = 'tbl' order by def_order;

-- verify SHOW CREATE TABLE
evaluate 'verify SHOW CREATE TABLE';
show create table tbl;

-- SELECT * should not include invisible column
evaluate 'SELECT * should not include invisible column';
select * from tbl;

-- explicit access should work
evaluate 'explicit access should work';
select c1,c2,c3 from tbl;

drop table if exists tbl;

create table tbl (
c1 int,
c2 int
);

insert into tbl values (10,20);

-- add invisible column at first position
evaluate 'add invisible column at first position';
alter table tbl add column c0 int invisible first;

-- verify metadata
evaluate 'verify metadata';
desc tbl;

-- verify column order via system catalog
evaluate 'verify column order via system catalog';
select attr_name, def_order from db_attribute where class_name = 'tbl' order by def_order;

-- verify SHOW CREATE TABLE
evaluate 'verify SHOW CREATE TABLE';
show create table tbl;

-- invisible column should not appear in SELECT *
evaluate 'invisible column should not appear in SELECT *';
select * from tbl;

-- explicit access
evaluate 'explicit access';
select c0,c1,c2 from tbl;

drop table if exists tbl;

create table tbl (
c1 int,
c2 int invisible,
c3 int
);

insert into tbl values (1,3);

-- verify metadata before drop
evaluate 'verify metadata before drop';
desc tbl;

-- verify column order via system catalog
evaluate 'verify column order via system catalog';
select attr_name, def_order from db_attribute where class_name = 'tbl' order by def_order;

-- drop invisible column
evaluate 'drop invisible column';
alter table tbl drop column c2;

-- verify metadata after drop
evaluate 'verify metadata after drop';
desc tbl;

-- verify column order via system catalog
evaluate 'verify column order via system catalog';
select attr_name, def_order from db_attribute where class_name = 'tbl' order by def_order;

show create table tbl;

-- verify data access
evaluate 'verify data access';
select * from tbl;

select c1,c3 from tbl order by 1;

-- verify column whether droped or not
evaluate 'verify column whether droped or not';
select c2 from tbl;

drop table if exists tbl;


-- Change visibility: invisible <-> visible
evaluate 'Change visibility: invisible <-> visible';
create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

-- invisible -> visible
evaluate 'invisible -> visible';
alter table t1 modify column c1 int visible;
desc t1;
select * from t1 order by id;

-- visible -> invisible
evaluate 'visible -> invisible';
alter table t1 modify column c1 int invisible;
desc t1;
select * from t1 order by id;

-- change column type of invisible column
evaluate 'change column type of invisible column';
alter table t1 modify column c1 bigint;
desc t1;

alter table t1 modify column c3 bigint invisible;
desc t1;

-- rename invisible column
evaluate 'rename invisible column';
alter table t1 change column c1 c1_renamed int invisible;
desc t1;
select id, c1_renamed, c2 from t1 order by id;

alter table t1 change column c1_renamed c1 int invisible;
desc t1;

drop table if exists t1;


-- ============================================
-- [3] TRUNCATE TABLE TESTS
-- ============================================

create table t1 (
    id int auto_increment invisible primary key,
    c1 int,
    c2 int invisible,
    c3 varchar(50)
);

insert into t1(c1, c2, c3) values (10, 20, 'a');
insert into t1(c1, c2, c3) values (11, 21, 'b');
insert into t1(c1, c2, c3) values (12, 22, 'c');

select id, c1, c2, c3 from t1 order by id;

truncate table t1;

-- table structure must be preserved after truncate
evaluate 'table structure must be preserved after truncate';
desc t1;

-- verify auto_increment reset
evaluate 'verify auto_increment reset';
insert into t1(c1, c2, c3) values (13, 23, 'd');
select id, c1, c2, c3 from t1 order by 1;

drop table if exists t1;


-- ============================================
-- [4] PARTITIONING WITH INVISIBLE COLUMNS
-- ============================================

create table tbl (c1 int invisible, c2 int) partition by hash(c1) partitions 2;

-- err: cannot drop partition key column
evaluate 'err: cannot drop partition key column';
/* err */ alter table tbl drop column c1;

-- partition table tests
evaluate 'partition table tests';
select * from tbl__p__p0 order by c1;
select * from tbl__p__p1 order by c1;
desc tbl__p__p0;
show create table tbl__p__p0;

alter table tbl remove partitioning;
desc tbl;

drop table if exists tbl;


-- ============================================
-- [5] INHERITANCE (SUPER/SUBCLASS) TESTS
-- ============================================

create table tbl (c1 int, c2 int);

-- err: cannot add invisible column to subclass
evaluate 'err: cannot add invisible column to subclass';
/* err */ create table tbl_son under tbl(c3 int invisible);

create table tbl_son under tbl;

-- err: cannot add invisible column via alter on subclass
evaluate 'err: cannot add invisible column via alter on subclass';
/* err */ alter table tbl_son add column c3 int invisible;

alter table tbl modify column c1 int invisible;
desc tbl;
desc tbl_son;

-- err: last visible column in subclass cannot become invisible
evaluate 'err: last visible column in subclass cannot become invisible';
/* err */ alter table tbl modify column c2 int invisible;

alter table tbl_son add column c3 int visible;
desc tbl;
desc tbl_son;

-- err: cannot make column invisible in subclass if parent has visible column
evaluate 'err: cannot make column invisible in subclass if parent has visible column';
/* err */ alter table tbl_son modify column c3 int invisible;

alter table tbl_son drop superclass tbl;
desc tbl;
desc tbl_son;

drop table if exists tbl_son;
drop table if exists tbl;


-- parent visibility changing / inheritance propagation
evaluate 'parent visibility changing / inheritance propagation';
create table tbl (
    c1 int auto_increment primary key,
    c2 int invisible not null,
    c3 int visible default 3,
    c4 int,
    c5 varchar(32)
);

create table tbl_son under tbl;
desc tbl;
desc tbl_son;

alter table tbl modify column c1 int auto_increment invisible;
desc tbl;
desc tbl_son;

drop tbl_son;

-- same name column: parent's c2 was invisible not null
evaluate 'same name column: parent c2 was invisible not null';
create table tbl_son under tbl(c2 int, c6 int);
desc tbl_son;

alter table tbl_son drop column c2;
desc tbl_son;
alter table tbl_son drop superclass tbl;
desc tbl_son;
drop table if exists tbl_son;
drop table if exists tbl;


-- ============================================
-- [6] CREATE TABLE LIKE TESTS
-- ============================================

create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

-- LIKE: invisible columns should be preserved
evaluate 'LIKE: invisible columns should be preserved';
create table t_like1 like t1;
desc t_like1;
show create table t_like1;

insert into t_like1(id, c1, c2, c3, c4) values (10, 100, 1000, 10000, 'like1');
select * from t_like1 order by 1;
select id, c1, c2, c3, c4 from t_like1 order by 1;

drop table if exists t_like1;
drop table if exists t1;


-- ============================================
-- [7] CREATE TABLE AS SELECT (CTAS) TESTS
-- ============================================

create table t1 (
    id int,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c');

-- CTAS with * (invisible columns NOT copied)
evaluate 'CTAS with * (invisible columns NOT copied)';
create table t_ctas1 as select * from t1;
desc t_ctas1;
select * from t_ctas1 order by id;

-- CTAS with explicit invisible columns
evaluate 'CTAS with explicit invisible columns';
create table t_ctas2 as select id, c1, c2, c3, c4 from t1;
desc t_ctas2;
select * from t_ctas2 order by id;

-- CTAS with WHERE using invisible column
evaluate 'CTAS with WHERE using invisible column';
create table t_ctas3 as select * from t1 where c1 > 15;
desc t_ctas3;
select * from t_ctas3 order by id;

-- CTAS with JOIN
evaluate 'CTAS with JOIN';
create table t2 (id int, c5 int invisible, c6 int, c7 varchar(50));
insert into t2(id, c5, c6, c7) values (1, 15, 150, 'x');
insert into t2(id, c5, c6, c7) values (2, 25, 250, 'y');

create table t_ctas4 as
    select t1.id, t1.c2, t2.c6
    from t1 join t2 on t1.id = t2.id;
desc t_ctas4;
select * from t_ctas4 order by id;

-- CTAS with aggregation
evaluate 'CTAS with aggregation';
create table t_ctas5 as
    select c2, count(*) as cnt, sum(c1) as sum_c1
    from t1
    group by c2;
desc t_ctas5;
select * from t_ctas5 order by c2;

drop table if exists t_ctas1;
drop table if exists t_ctas2;
drop table if exists t_ctas3;
drop table if exists t_ctas4;
drop table if exists t_ctas5;
drop table if exists t2;
drop table if exists t1;
