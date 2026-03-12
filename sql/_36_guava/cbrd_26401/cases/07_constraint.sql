-- ============================================
-- CONSTRAINT TESTS - INVISIBLE COLUMN
-- INDEX / FOREIGN KEY / UNIQUE / NOT NULL / CHECK
-- ============================================

-- ============================================
-- [1] INDEX WITH INVISIBLE COLUMNS
-- ============================================

drop table if exists t1;

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 int invisible,
    c4 varchar(100)
);

create index idx_cA on t1(c1);
create index idx_cA_cB on t1(c1, c2);
create index idx_cB_cA on t1(c2, c1);
create index idx_cC_cD on t1(c3, c4);
create index idx_cA_cC on t1(c1, c3);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 20, 30, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 11, 21, 31, 'b');
insert into t1(id, c1, c2, c3, c4) values (3, 12, 22, 32, 'c');

set trace on;

-- verify index metadata
evaluate 'verify index metadata';
show index from t1;

update statistics on t1;

-- verify index metadata
evaluate 'verify index metadata';
show index from t1;

-- select invisible column
evaluate 'select invisible column';
select /*+recompile*/ c1 from t1;
show trace;

-- index scan with invisible columns
evaluate 'index scan with invisible columns';
select /*+recompile*/ c1, c2 from t1 where c1 = 10 order by 1;
show trace;

select /*+recompile*/ c2 from t1 where c1 > 10 order by c1;
show trace;

select /*+recompile*/ * from t1 where c1 = 10 order by 1;
show trace;

-- c2 is visible. c2 is first column of idx_c2_c1
evaluate 'c2 is visible. c2 is first column of idx_c2_c1';
select /*+recompile*/ * from t1 where c2 = 20;
show trace;

-- c1, c3 both invisible. idx_c1_c3
evaluate 'c1, c3 both invisible. idx_c1_c3';
select /*+recompile*/ * from t1 where c1 = 10 and c3 = 30;
show trace;

-- idx_c3_c4
evaluate 'idx_c3_c4';
select /*+recompile*/ c1,c2,c3 from t1 where c3 = 31;
show trace;

select /*+recompile*/ * from t1 where c4 = 'c' order by 1;
show trace;

-- covering index test
evaluate 'covering index test';
select /*+recompile*/ c1, c2 from t1 where c1 between 10 and 12 order by c1;
show trace;

-- index with invisible column in WHERE but not in SELECT
evaluate 'index with invisible column in WHERE but not in SELECT';
select /*+recompile*/ c2, c4 from t1 where c1 = 11;
show trace;

set trace off;

-- SHOW INDEX: should show all indexes including ones on invisible columns
evaluate 'SHOW INDEX: should show all indexes including ones on invisible columns';
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

show index from t1;

drop table if exists t1;


-- ============================================
-- [2] FOREIGN KEY WITH INVISIBLE COLUMNS
-- ============================================

drop table if exists t_child;
drop table if exists t_parent;

-- FK referencing invisible column
evaluate 'FK referencing invisible column';
create table t_parent (
    id int invisible primary key,
    c1 int invisible,
    c2 int
);

create table t_child (
    id int primary key,
    parent_id int,
    c3 int invisible,
    foreign key (parent_id) references t_parent(id)
);

insert into t_parent(id, c1, c2) values (1, 10, 100);
insert into t_parent(id, c1, c2) values (2, 20, 200);

insert into t_child(id, parent_id, c3) values (1, 1, 1000);
insert into t_child(id, parent_id, c3) values (2, 2, 2000);

-- err: FK violation
evaluate 'err: FK violation';
/* err */ insert into t_child(id, parent_id, c3) values (3, 999, 3000);

select * from t_child order by id;
select id, c3 from t_child order by id;

-- change visibility of referenced column
evaluate 'change visibility of referenced column';
/* err */ alter table t_parent modify column id int visible;
alter table t_parent modify column id int invisible;

drop table if exists t_child;
drop table if exists t_parent;


-- ============================================
-- [3] UNIQUE / NOT NULL / CHECK CONSTRAINTS
-- ============================================

create table t_const (
    id int primary key,
    c1 int invisible unique,
    c2 int invisible not null,
    c3 int check (c3 > 0),
    c4 int invisible check (c4 > 0),
    c5 varchar(50)
);

insert into t_const(id, c1, c2, c3, c4, c5) values (1, 10, 20, 30, 40, 'a');

-- err: unique violation on invisible column
evaluate 'err: unique violation on invisible column';
/* err */ insert into t_const(id, c1, c2, c3, c4, c5) values (2, 10, 21, 31, 41, 'b');

-- err: not null violation on invisible column
evaluate 'err: not null violation on invisible column';
/* err */ insert into t_const(id, c1, c3, c4, c5) values (3, 11, 32, 42, 'c');

-- note: CHECK constraint not supported in CUBRID
-- /* err */ insert into t_const(id, c1, c2, c3, c4, c5) values (4, 12, 22, 33, -1, 'd');

insert into t_const(id, c1, c2, c3, c4, c5) values (5, 15, 25, 35, 45, 'e');

select * from t_const order by id;
select id, c1, c2, c3, c4, c5 from t_const order by id;

drop table if exists t_const;


-- ============================================
-- [4] INDEX ON TABLE WITH DDL CHANGES
-- ============================================

create table tbl (
    c1 int auto_increment invisible primary key,
    c2 int invisible not null,
    c3 int invisible default 3,
    c4 int,
    c5 varchar(32)
) partition by hash (c1) partitions 2;

create index tbl_c1_c2_idx on tbl (c1, c2);

insert into tbl(c2, c4, c5) values (2, 4, '5');
insert into tbl(c2, c5) values (12, '15');

-- alter visibility and check index still works
evaluate 'alter visibility and check index still works';
alter table tbl modify column c5 varchar(32) invisible;
evaluate 'err (at least one visible)';
/* err (at least one visible) */ alter table tbl change column c4 c4 int invisible;

desc tbl;
select * from tbl order by c4;

-- re-make visible
evaluate 're-make visible';
alter table tbl change column c5 c5 varchar(32) visible;
drop table if exists tbl;
