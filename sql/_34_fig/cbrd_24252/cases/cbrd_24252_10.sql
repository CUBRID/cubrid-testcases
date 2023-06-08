set trace on;

/* dummy data */
drop table if exists dummy;
create table dummy (c1 int);
insert into dummy
select rownum from
table ({0, 1, 2, 3, 4, 5, 6, 7, 8, 9}),
table ({0, 1, 2, 3, 4, 5, 6, 7, 8, 9}),
table ({0, 1, 2, 3, 4, 5, 6, 7, 8, 9});

/* ----------------------------------------
 *
 * test case 10
 *   - child c (parent_c1:not_null)
 *   - sub parent p (c:parent_c1->p:c1)
 *   - super parent s
 *
 * ---------------------------------------- */

drop table if exists t10_child;
drop table if exists t10_parent;
drop table if exists t10_super_parent;
create table t10_super_parent (c1 int primary key auto_increment, c2 int);
create table t10_parent under t10_super_parent (c3 int);
create table t10_child (c1 int auto_increment primary key, c2 int);
alter table t10_child add column parent_c1 int not null references t10_parent (c1); /* not_null */
insert into t10_super_parent select null, c1 from dummy;
insert into t10_parent select null, (c1 * -1), c1 from dummy;
insert into t10_parent select null, (c1 * -1), c1 from dummy;
insert into t10_child select null, (c1 * -1), c1 from dummy;
insert into t10_child select null, (c1 * -1), c1 from dummy;
insert into t10_child select null, (c1 * -1), c1 from dummy;
insert into t10_child select null, (c1 * -1), c1 from dummy;

select /*+ recompile */
    c.c1,
    c.c2
from
    t10_parent as p
    inner join t10_child as c on c.parent_c1 = p.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t10_child as c,
    t10_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1;
show trace;

drop table if exists t10_child;
drop table if exists t10_parent;
drop table if exists t10_super_parent;


drop table if exists dummy;

set trace off;
