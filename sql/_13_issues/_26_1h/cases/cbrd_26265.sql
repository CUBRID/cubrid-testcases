/**
 *  This test case verifies CBRD-26265: 
 *  Remove redundant IS NOT NULL predicates on columns declared NOT NULL
 *
 *  Test Coverage:
 *      1. IS NOT NULL on NOT NULL column
 *      2. IS NOT NULL with additional filter
 *      3. IS NOT NULL in LIKE predicate
 *      4. IS NOT NULL in LIKE predicate with variable binding
 *      5. IS NOT NULL in complex LIKE expression
 *      6. IS NOT NULL in complex LIKE expression with variable binding
 *      7. IS NOT NULL + complex LIKE on NOT NULL column (regression from review)
 *      8. OR combination (should not break logic)
 *      9. not null column, is not null
 *      10. not null column, like ''%''
 *      11. not null column, like ''%'' || '''' || ''%''
 *      12. type mismatch, not null column, is not null
 *      13. type mismatch, not null column, like ''%''
 *      14. type mismatch, not null column, like ''%'' || '''' || ''%''
 *      15. pk column, is not null
 *      16. pk column, like ''%''
 *      17. pk column, like ''%'' || '''' || ''%''
 *      18. join query, is not null
 */
set trace on;

evaluate concat('1. IS NOT NULL on NOT NULL column');
drop table if exists tbl_w;
create table tbl_w (
    col1 int not null,
    col2 int
);

insert into tbl_w (col1, col2) values(1, 100);

select * from tbl_w where col1 is not null;
show trace;

evaluate concat('2. IS NOT NULL with additional filter');
drop table if exists tbl_x;
create table tbl_x (
    a int not null,
    b varchar(20)
);

insert into tbl_x (a, b) values(1, 'abcdef');
insert into tbl_x (a, b) values(2, 'hello');

select * from tbl_x where a is not null and b = 'hello';
show trace;

evaluate concat('3. IS NOT NULL in LIKE predicate');
drop table if exists tbl_y;
create table tbl_y (
    c int not null,
    d varchar(20),
    e varchar(20) not null
);

insert into tbl_y (c, d, e) values(1, null, 'abcdef');
insert into tbl_y (c, d, e) values(2, null, 'hello');
insert into tbl_y (c, d, e) values(3, null, 'test');

select * from tbl_y where e like '%';
show trace;

evaluate concat('4. IS NOT NULL in LIKE predicate with variable binding');
select * from tbl_y where e like '?';
show trace;

evaluate concat('5. IS NOT NULL in complex LIKE expression');
drop table if exists tbl_z;
create table tbl_z (
    x int not null,
    y varchar(20),
    z varchar(20) not null
);

insert into tbl_z (x, y, z) values(1, null, 'hi');
insert into tbl_z (x, y, z) values(2, null, 'cubrid');
insert into tbl_z (x, y, z) values(3, null, 'test');

select * from tbl_z where z like '%' || '' || '%';
show trace;

evaluate concat('6. IS NOT NULL in complex LIKE expression with variable binding');
select * from tbl_z where z like '?' || '' || '?';
show trace;

evaluate concat('7. IS NOT NULL + complex LIKE on NOT NULL column (regression from review)');
drop table if exists tbl_r;
create table tbl_r (
    col1 varchar(20) not null,
    col2 int
);

insert into tbl_r values ('a', 1);
insert into tbl_r values ('b', 2);

select /*+ recompile */ * from tbl_r where (col1 is not null and col1 like '%' || '' || '%');
show trace;

evaluate concat('8. OR combination (should not break logic)');
drop table if exists tbl_or;
create table tbl_or (
    col1 int not null, 
    col2 int
);

insert into tbl_or values (1, null);
insert into tbl_or values (2, 10);

select /*+ recompile */ * from tbl_or where (col1 is not null or col2 = 10);
show trace;

set optimization level 513;

drop table if exists t1;
create table t1(
    col1 varchar not null
);

insert into t1 values ('a');

evaluate concat('9. not null column, is not null');
select /*+ recompile */ * from t1 where col1 is not null;
show trace;

evaluate concat('10. not null column, like ''%''');
select /*+ recompile */ * from t1 where col1 like '%';
show trace;

evaluate concat('11. not null column, like ''%'' || '''' || ''%''');
select /*+ recompile */ * from t1 where col1 like '%' || '' || '%';
show trace;

drop table if exists t2;
create table t2(
    col1 int not null
);

insert into t2 values (1);

evaluate concat('12. type mismatch, not null column, is not null');
select /*+ recompile */ * from t2 where col1 is not null;
show trace;

evaluate concat('13. type mismatch, not null column, like ''%''');
select /*+ recompile */ * from t2 where col1 like '%';
show trace;

evaluate concat('14. type mismatch, not null column, like ''%'' || '''' || ''%''');
select /*+ recompile */ * from t2 where col1 like '%' || '' || '%';
show trace;

drop table if exists t1;
create table t1 (
    col1 varchar, 
    primary key(col1)
);

insert into t1 (col1) values ('abc');
insert into t1 (col1) values ('def');

evaluate concat('15. pk column, is not null');
select /*+ recompile */ * from t1 where col1 is not null;
show trace;

evaluate concat('16. pk column, like ''%''');
select /*+ recompile */ * from t1 where col1 like '%';
show trace;

evaluate concat('17. pk column, like ''%'' || '''' || ''%''');
select /*+ recompile */ * from t1 where col1 like '%' || '' || '%';
show trace;

evaluate concat('18. join query, is not null');
drop table if exists t1, t2;
create table t1 (
    col1 varchar(20) not null,
    col2 int
);

insert into t1 values ('abc', 1);
insert into t1 values ('def', 2);

create table t2(
    col1 int
);

insert into t2 (col1) values (111);
insert into t2 (col1) values (222);

select /*+ recompile */ * from t1 left outer join t2 on t1.col2 = t2.col1 and t1.col1 like '%' || '' || '%';
show trace;

-- cleanup
drop table tbl_w;
drop table tbl_x;
drop table tbl_y;
drop table tbl_z;
drop table tbl_r;
drop table t1;
drop table t2;
drop table tbl_or;
set trace off;
