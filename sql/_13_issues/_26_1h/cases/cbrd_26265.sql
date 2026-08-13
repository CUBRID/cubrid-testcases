/**
 *  This test case verifies CBRD-26265: 
 *  Remove redundant IS NOT NULL predicates on columns declared NOT NULL
 *
 *  Test Coverage:
 *      1. IS NOT NULL on NOT NULL column
 *      2. IS NOT NULL with additional filter
 *      3. IS NOT NULL in LIKE predicate
 *      4. IS NOT NULL in LIKE predicate with literal "?"
 *      5. IS NOT NULL in complex LIKE expression
 *      6. IS NOT NULL in complex LIKE expression with literal "?"
 *      7. IS NOT NULL + complex LIKE on NOT NULL column (regression from review)
 *      8. OR combination (should not break logic)
 *      9. type mismatch, not null column, is not null
 *      10. type mismatch, not null column, like ''%''
 *      11. type mismatch, not null column, like ''%'' || '''' || ''%''
 *      12. pk column, is not null
 *      13. pk column, like ''%''
 *      14. pk column, like ''%'' || '''' || ''%''
 *      15. join query, is not null
 *      16. not null column, like bind parameter, hostvar_peeking=no
 *      17. not null column, like ''%'' || bind parameter || ''%'', hostvar_peeking=no
 *      18. not null column, like bind parameter, hostvar_peeking=yes
 *      19. not null column, like ''%'' || bind parameter || ''%'', hostvar_peeking=yes
 *      20. type mismatch, not null column, like bind parameter, hostvar_peeking=yes
 *      21. type mismatch, not null column, like ''%'' || bind parameter || ''%'', hostvar_peeking=yes
 *      22. pk column, like bind parameter, hostvar_peeking=yes
 *      23. pk column, like ''%'' || bind parameter || ''%'', hostvar_peeking=yes
 *      24. join query, like ''%'' || bind parameter || ''%'', hostvar_peeking=yes
 */
set trace on;

evaluate concat('1. IS NOT NULL on NOT NULL column');
drop table if exists tbl_w;
create table tbl_w (
    cola int not null,
    colb int
);

insert into tbl_w (cola, colb) values(1, 100);

select * from tbl_w where cola is not null;
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

evaluate concat('4. IS NOT NULL in LIKE predicate with literal "?"');
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

evaluate concat('6. IS NOT NULL in complex LIKE expression with literal "?"');
select * from tbl_z where z like '?' || '' || '?';
show trace;

evaluate concat('7. IS NOT NULL + complex LIKE on NOT NULL column (regression from review)');
drop table if exists tbl_r;
create table tbl_r (
    cola varchar(20) not null,
    colb int
);

insert into tbl_r values ('a', 1);
insert into tbl_r values ('b', 2);

select /*+ recompile */ * from tbl_r where (cola is not null and cola like '%' || '' || '%');
show trace;

evaluate concat('8. OR combination (should not break logic)');
drop table if exists tbl_or;
create table tbl_or (
    cola int not null, 
    colb int
);

insert into tbl_or values (1, null);
insert into tbl_or values (2, 10);

select /*+ recompile */ * from tbl_or where (cola is not null or colb = 10);
show trace;

drop table if exists tbl_b;
create table tbl_b(
    cola int not null
);

insert into tbl_b values (1);

evaluate concat('9. type mismatch, not null column, is not null');
select /*+ recompile */ * from tbl_b where cola is not null;
show trace;

evaluate concat('10. type mismatch, not null column, like ''%''');
select /*+ recompile */ * from tbl_b where cola like '%';
show trace;

evaluate concat('11. type mismatch, not null column, like ''%'' || '''' || ''%''');
select /*+ recompile */ * from tbl_b where cola like '%' || '' || '%';
show trace;

drop table if exists tbl_a;
create table tbl_a (
    cola varchar, 
    primary key(cola)
);

insert into tbl_a (cola) values ('abc');
insert into tbl_a (cola) values ('def');

evaluate concat('12. pk column, is not null');
select /*+ recompile */ * from tbl_a where cola is not null;
show trace;

evaluate concat('13. pk column, like ''%''');
select /*+ recompile */ * from tbl_a where cola like '%';
show trace;

evaluate concat('14. pk column, like ''%'' || '''' || ''%''');
select /*+ recompile */ * from tbl_a where cola like '%' || '' || '%';
show trace;

evaluate concat('15. join query, is not null');
drop table if exists tbl_a, tbl_b;
create table tbl_a (
    cola varchar(20) not null,
    colb int
);

insert into tbl_a values ('abc', 1);
insert into tbl_a values ('def', 2);

create table tbl_b(
    cola int
);

insert into tbl_b (cola) values (111);
insert into tbl_b (cola) values (222);

select /*+ recompile */ * from tbl_a left outer join tbl_b on tbl_a.colb = tbl_b.cola and tbl_a.cola like '%' || '' || '%';
show trace;

drop table if exists tbl_a, tbl_b;
create table tbl_a (
    cola varchar not null
);

SET SYSTEM PARAMETERS 'hostvar_peeking=no';

prepare q1 from 'select /*+ recompile */ * from tbl_a where cola like ?';
prepare q2 from 'select /*+ recompile */ * from tbl_a where cola like ''%'' || ? || ''%''';

evaluate concat('16. NOT NULL column with LIKE bind parameter, hostvar_peeking=no');
execute q1 using '%';
show trace;

evaluate concat('17. NOT NULL column with complex LIKE bind parameter, hostvar_peeking=no');
execute q2 using '';
show trace;

SET SYSTEM PARAMETERS 'hostvar_peeking=yes';

evaluate concat('18. NOT NULL column with LIKE bind parameter, hostvar_peeking=yes');
execute q1 using '%';
show trace;

evaluate concat('19. NOT NULL column with complex LIKE bind parameter, hostvar_peeking=yes');
execute q2 using '';
show trace;

drop table if exists tbl_b;

create table tbl_b (
    cola int not null
);

prepare q1 from 'select /*+ recompile */ * from tbl_b where cola like ?';
prepare q2 from 'select /*+ recompile */ * from tbl_b where cola like ''%'' || ? || ''%''';

evaluate concat('20. Type mismatch with LIKE bind parameter, hostvar_peeking=yes');
execute q1 using '%';
show trace;

evaluate concat('21. Type mismatch with complex LIKE bind parameter, hostvar_peeking=yes');
execute q2 using '';
show trace;

drop table if exists tbl_a;

create table tbl_a (
    cola varchar,
    primary key (cola)
);

prepare q1 from 'select /*+ recompile */ * from tbl_a where cola like ?';
prepare q2 from 'select /*+ recompile */ * from tbl_a where cola like ''%'' || ? || ''%''';

evaluate concat('22. Primary key column with LIKE bind parameter, hostvar_peeking=yes');
execute q1 using '%';
show trace;

evaluate concat('23. Primary key column with complex LIKE bind parameter, hostvar_peeking=yes');
execute q2 using '';
show trace;

drop table if exists tbl_a, tbl_b;

create table tbl_a (
    cola varchar not null,
    colb int
);

create table tbl_b (
    cola int
);

prepare q1 from 'select /*+ recompile */ * from tbl_a left outer join tbl_b on tbl_a.colb = tbl_b.cola and tbl_a.cola like ''%'' || ? || ''%''';

evaluate concat('24. Join query with complex LIKE bind parameter, hostvar_peeking=yes');
execute q1 using '';
show trace;

-- cleanup
drop table tbl_w;
drop table tbl_x;
drop table tbl_y;
drop table tbl_z;
drop table tbl_r;
drop table tbl_or;
drop table tbl_a;
drop table tbl_b;
set trace off;
