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
 * test case 12
 *   - child (parent_c1:not_null)
 *   - sub parent p
 *   - super parent s (c:parent_c1->s:c1)
 *
 * ---------------------------------------- */

drop table if exists t12_child;
drop table if exists t12_parent;
drop table if exists t12_super_parent;
create table t12_super_parent (c1 int primary key auto_increment, c2 int);
create table t12_parent as subclass of t12_super_parent (c3 int);
create table t12_child (c1 int auto_increment primary key, c2 int);
alter table t12_child add column parent_c1 int not null references t12_parent (c1); /* not_null */
insert into t12_super_parent select null, c1 from dummy;
insert into t12_parent select null, (c1 * -1), c1 from dummy;
insert into t12_parent select null, (c1 * -1), c1 from dummy;
insert into t12_child select null, (c1 * -1), c1 from dummy;
insert into t12_child select null, (c1 * -1), c1 from dummy;
insert into t12_child select null, (c1 * -1), c1 from dummy;
insert into t12_child select null, (c1 * -1), c1 from dummy;

select /*+ recompile */
    c.c1,
    c.c2
from
    t12_super_parent as s
    inner join t12_child as c on c.parent_c1 = s.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t12_child as c,
    t12_super_parent as s
where
    c.parent_c1 = s.c1
    and c.c2 = -1;
show trace;

drop table if exists t12_child;
drop table if exists t12_parent;
drop table if exists t12_super_parent;



drop table if exists dummy;

set trace off;
