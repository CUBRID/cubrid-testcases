-- ============================================
-- DML TESTS - INVISIBLE COLUMN
-- INSERT / UPDATE / DELETE / REPLACE / MERGE
-- ============================================

-- ============================================
-- [1] INSERT TESTS
-- ============================================

drop table if exists tbl;


create table tbl (
    c1 int auto_increment invisible primary key,
    c2 int visible not null,
    c3 int invisible default 3,
    c4 int,
    c5 varchar(32)
);

-- err: c1/c2/c3 invisible, so values (1,2,3,4,'5') is mismatched
evaluate 'err: c1/c2/c3 invisible, so values (1,2,3,4,''5'') is mismatched';
/* err */ insert into tbl values (1, 2, 3, 4, '5');

-- valid: only visible columns provided
evaluate 'valid: only visible columns provided';
insert into tbl values (2, 4, '5');

alter table tbl change c2 c2 int invisible;
desc tbl;

-- err: c2 not null constraint but not specified
evaluate 'err: c2 not null constraint but not specified';
/* err */ insert into tbl() values (4, '5');

insert into tbl(c2, c4, c5) values (2, 4, '5');
insert into tbl(c2, c5) values (12, '15');
insert into tbl(c2, c5) values (22, '25'), (32, '35');

select * from tbl order by 1;
select c1,c2,c3,c4,c5 from tbl order by 1;

drop table if exists tbl;


-- ============================================
-- [2] INSERT DEFAULT VALUES TESTS
-- ============================================

create table t1 (
    id int auto_increment invisible primary key,
    c1 int invisible default 100,
    c2 int default 200,
    c3 int invisible default 300
);

-- insert with all defaults
evaluate 'insert with all defaults';
insert into t1 default values;
insert into t1 default values;
select id, c1, c2, c3 from t1 order by id;

-- insert specifying only some columns
evaluate 'insert specifying only some columns';
insert into t1(c2) values (250);
select id, c1, c2, c3 from t1 order by id;

drop table if exists t1;

-- err: all columns invisible and some without defaults
evaluate 'err: all columns invisible and some without defaults';
/* err - no visible column */ create table t1 (c1 int invisible, c2 int invisible);
drop table if exists t1;


-- ============================================
-- [3] INSERT ... SELECT TESTS
-- ============================================

create table t1 (id int, c1 int invisible, c2 int, c3 varchar(50));
create table t2 (id int, c1 int invisible, c2 int, c3 varchar(50));

insert into t1(id, c1, c2, c3) values (1, 10, 100, 'a');
insert into t1(id, c1, c2, c3) values (2, 20, 200, 'b');

-- INSERT ... SELECT * (invisible columns NOT included)
evaluate 'INSERT ... SELECT * (invisible columns NOT included)';
insert into t2 select * from t1;
select id, c1, c2, c3 from t2 order by id;

-- INSERT ... SELECT with explicit invisible columns
evaluate 'INSERT ... SELECT with explicit invisible columns';
delete from t2;
insert into t2(id, c1, c2, c3) select id, c1, c2, c3 from t1;
select id, c1, c2, c3 from t2 order by id;

-- INSERT ... SELECT with WHERE on invisible column
evaluate 'INSERT ... SELECT with WHERE on invisible column';
delete from t2;
insert into t2(id, c2, c3) select id, c2, c3 from t1 where c1 > 15;
select id, c1, c2, c3 from t2 order by id;

drop table if exists t2;
drop table if exists t1;


-- ============================================
-- [4] UPDATE TESTS
-- ============================================

create table tbl (
    c1 int auto_increment invisible primary key,
    c2 int visible not null,
    c3 int invisible default 3,
    c4 int,
    c5 varchar(32)
);

insert into tbl(c2, c4, c5) values (2, 4, '5');
insert into tbl(c2, c5) values (12, '15');

update tbl set c2 = 0 where c1 = 1;
select c1, c2, c3, c4, c5 from tbl order by c1;

-- on update clause test
evaluate 'on update clause test';
alter table tbl add column updated_date datetime invisible on update current_timestamp;
update tbl set c2 = 0 where c1 = 1;
select c1, c2, c3, c4, c5, if(current_datetime -updated_date >=0 and current_datetime -updated_date <10000,'ok','nok') from tbl order by c1;

drop table if exists tbl;


-- ============================================
-- [5] DELETE TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

insert into t1(id, c1, c2, c3) values (1, 10, 100, 'a');
insert into t1(id, c1, c2, c3) values (2, 20, 200, 'b');
insert into t1(id, c1, c2, c3) values (3, 30, 300, 'c');

-- delete using invisible column in WHERE
evaluate 'delete using invisible column in WHERE';
delete from t1 where c1 = 10;
select id, c1, c2, c3 from t1 order by id;

-- delete using invisible column via join condition
evaluate 'delete using invisible column via join condition';
create table t2 (id int primary key, c4 int invisible, c5 int);
insert into t2(id, c4, c5) values (2, 20, 22);

delete t1 from t1, t2 where t1.c1 = t2.c4 and t1.id = 2;
select id, c1, c2, c3 from t1 order by id;

drop table if exists t2;
drop table if exists t1;


-- ============================================
-- [6] REPLACE INTO TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int unique,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE with duplicate PK (should delete and re-insert)
replace into t1(id, c1, c2, c3, c4) values (1, 11, 101, 1001, 'a1');
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE without specifying invisible columns
replace into t1(id, c2, c4) values (2, 202, 'b2');
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE with duplicate UNIQUE index
replace into t1 set c2 = 101, id = 3, c4 = 'c';
select id, c1, c2, c3, c4 from t1 order by id;

-- REPLACE with SELECT
evaluate 'REPLACE with SELECT';
create table t2 (id int, val int, name varchar(50));
insert into t2 values (4, 400, 'd'), (5, 500, 'e');
replace into t1(id, c2, c4) select id, val, name from t2;
select id, c1, c2, c3, c4 from t1 order by id;

drop table if exists t2;
drop table if exists t1;


-- ============================================
-- [7] INSERT ... ON DUPLICATE KEY UPDATE TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int unique,
    c3 int invisible,
    c4 varchar(50)
);

insert into t1(id, c1, c2, c3, c4) values (1, 10, 100, 1000, 'a');
insert into t1(id, c1, c2, c3, c4) values (2, 20, 200, 2000, 'b');

-- update invisible column on duplicate
evaluate 'update invisible column on duplicate';
insert into t1(id, c1, c2, c4) values (1, 15, 105, 'a_updated')
    on duplicate key update c1 = 15, c4 = 'a_updated';
select id, c1, c2, c3, c4 from t1 order by id;

-- insert new row (no duplicate)
evaluate 'insert new row (no duplicate)';
insert into t1(id, c1, c2, c3, c4) values (3, 30, 300, 3000, 'c')
    on duplicate key update c1 = 35;
select id, c1, c2, c3, c4 from t1 order by id;

-- only visible column in INSERT but invisible in UPDATE clause
evaluate 'only visible column in INSERT but invisible in UPDATE clause';
insert into t1(id, c2, c4) values (3, 301, 'c_updated')
    on duplicate key update c1 = 31, c3 = 3001;
select id, c1, c2, c3, c4 from t1 order by id;

drop table if exists t1;


-- ============================================
-- [8] MERGE TESTS
-- ============================================

create table t_target (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

create table t_source (
    id int,
    c1_new int,
    c2_new int,
    c3_new varchar(50)
);

insert into t_target(id, c1, c2, c3) values (1, 10, 100, 'old1');
insert into t_target(id, c1, c2, c3) values (2, 20, 200, 'old2');

insert into t_source values (2, 25, 250, 'new2');
insert into t_source values (3, 30, 300, 'new3');

-- MERGE with invisible column
merge into t_target t
using t_source s on t.id = s.id
when matched then
    update set t.c1 = s.c1_new, t.c2 = s.c2_new, t.c3 = s.c3_new
when not matched then
    insert (id, c1, c2, c3) values (s.id, s.c1_new, s.c2_new, s.c3_new);

select id, c1, c2, c3 from t_target order by id;

-- MERGE with condition using invisible column
evaluate 'MERGE with condition using invisible column';
delete from t_source;
insert into t_source values (1, 15, 150, 'update1');
insert into t_source values (4, 40, 400, 'new4');

merge into t_target t
using t_source s on t.id = s.id
when matched then
    update set t.c2 = s.c2_new where t.c1 < s.c1_new
when not matched then
    insert (id, c1, c2, c3) values (s.id, s.c1_new, s.c2_new, s.c3_new);

select id, c1, c2, c3 from t_target order by id;

drop table if exists t_source;
drop table if exists t_target;


-- ============================================
-- [9] UPDATE/DELETE WITH JOIN TESTS
-- ============================================

create table t1 (
    id int primary key,
    c1 int invisible,
    c2 int,
    c3 varchar(50)
);

create table t2 (
    id int primary key,
    c4 int invisible,
    c5 int
);

insert into t1(id, c1, c2, c3) values (1, 10, 100, 'a');
insert into t1(id, c1, c2, c3) values (2, 20, 200, 'b');
insert into t1(id, c1, c2, c3) values (3, 30, 300, 'c');

insert into t2(id, c4, c5) values (1, 110, 11);
insert into t2(id, c4, c5) values (2, 220, 22);

-- UPDATE: set invisible column from joined table
evaluate 'UPDATE: set invisible column from joined table';
update t1, t2 set t1.c1 = t2.c4 where t1.id = t2.id;
select id, c1, c2, c3 from t1 order by id;

-- DELETE using invisible column in join condition
evaluate 'DELETE using invisible column in join condition';
delete t1 from t1, t2 where t1.c1 = t2.c4 and t1.id = 1;
select id, c1, c2, c3 from t1 order by id;

drop table if exists t2;
drop table if exists t1;


-- ============================================
-- [10] MULTI-TABLE UPDATE/DELETE
-- ============================================

create table t1 (id int primary key, c1 int invisible, c2 int);
create table t2 (id int primary key, c3 int invisible, c4 int);

insert into t1(id, c1, c2) values (1, 10, 100);
insert into t1(id, c1, c2) values (2, 20, 200);
insert into t2(id, c3, c4) values (1, 30, 300);
insert into t2(id, c3, c4) values (2, 40, 400);

-- multi-table update using invisible columns
evaluate 'multi-table update using invisible columns';
update t1, t2
set t1.c1 = t1.c1 + 5, t2.c3 = t2.c3 + 10
where t1.id = t2.id and t1.c1 > 15;

select id, c1, c2 from t1 order by id;
select id, c3, c4 from t2 order by id;

drop table if exists t2;
drop table if exists t1;
