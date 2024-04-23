-- This test case verifies the CBRD-25277 issue.
-- 'Outer join query optimization failed.' error occurs in Eliminate INNER JOIN


select '' as "test data";

drop table if exists tb_child;
drop table if exists ta_parent;
drop table if exists tc_dummy;

create table ta_parent (c_a int primary key, c_b int);
create table tb_child (c_a int primary key, c_b int);
alter table tb_child add parent_c_a int not null references ta_parent (c_a);
create table tc_dummy (c_a int primary key, c_b int);

insert into ta_parent values (1, 1);
insert into tb_child values (2, 2, 1);
insert into tb_child values (3, 3, 1);
insert into tc_dummy values (2, 20);
insert into tc_dummy values (4, 40);

update statistics on ta_parent with fullscan;
update statistics on tb_child with fullscan;
update statistics on tc_dummy with fullscan;


select 'AS-IS - Outer join query optimization failed.
TO-BE
- Eliminate INNER JOIN for the first table
- INNER JOIN
- With ANSI JOIN syntax
' as "test case 1";

select /*+ recompile ordered */
  c.c_b, d.c_b
from
  ta_parent p
  inner join tb_child c on c.parent_c_a = p.c_a
  inner join tc_dummy d
    on d.c_a = c.c_a;


select 'AS-IS - No error with ORACLE JOIN syntax.
TO-BE
- Eliminate INNER JOIN for the first table
- INNER JOIN
- With ORACLE JOIN syntax
' as "test case 2";

select /*+ recompile ordered */
  c.c_b, d.c_b
from
  ta_parent p
  inner join tb_child c on c.parent_c_a = p.c_a,
  tc_dummy d
where
  d.c_a = c.c_a;


select 'AS-IS - Outer join query optimization failed.
TO-BE
- Eliminate INNER JOIN for the first table
- LEFT OUTER JOIN
- With ANSI JOIN syntax
' as "test case 3";

select /*+ recompile ordered */
  c.c_b, d.c_b
from
  ta_parent p
  inner join tb_child c on c.parent_c_a = p.c_a
  left outer join tc_dummy d
    on d.c_a = c.c_a;


select 'AS-IS - Outer join query optimization failed.
TO-BE
- Eliminate INNER JOIN for the first table
- LEFT OUTER JOIN
- With ORACLE JOIN syntaxi
' as "test case 4";

select /*+ recompile ordered */
  c.c_b, d.c_b
from
  ta_parent p,
  tb_child c,
  tc_dummy d
where
  c.parent_c_a = p.c_a
  and d.c_a(+) = c.c_a;


select 'AS-IS - Outer join query optimization failed.
TO-BE
- Eliminate INNER JOIN for the first table
- RIGHT OUTER JOIN
- With ANSI JOIN syntax
' as "test case 5";

select /*+ recompile ordered */
  c.c_b, d.c_b
from
  ta_parent p
  inner join tb_child c on c.parent_c_a = p.c_a
  right outer join tc_dummy d
    on d.c_a = c.c_a;


select 'AS-IS - a class may be outer joined to at most one other class
- Eliminate INNER JOIN for the first table
- RIGHT OUTER JOIN
- With ORACLE JOIN syntax
=> In ORACLE, RIGHT OUTER JOIN is performed without error.
' as "test case 6";

select /*+ recompile ordered no_eliminate_join */
  c.c_b, d.c_b
from
  ta_parent p,
  tb_child c,
  tc_dummy d
where
  c.parent_c_a(+) = p.c_a
  and d.c_a = c.c_a(+);

drop tb_child;
drop ta_parent;
drop tc_dummy;
