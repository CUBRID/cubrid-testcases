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
 * test case 11
 *   - child c (parent_c1:null)
 *   - sub parent p (c:parent_c1->p:c1)
 *   - super parent s
 *
 * ---------------------------------------- */

drop table if exists t11_child;
drop table if exists t11_parent;
drop table if exists t11_super_parent;
create table t11_super_parent (c1 int primary key auto_increment, c2 int);
create table t11_parent under t11_super_parent (c3 int);
create table t11_child (c1 int auto_increment primary key, c2 int);
alter table t11_child add column parent_c1 int references t11_parent (c1); /* null */
insert into t11_super_parent select null, c1 from dummy;
insert into t11_parent select null, (c1 * -1), c1 from dummy;
insert into t11_parent select null, (c1 * -1), c1 from dummy;
insert into t11_child select null, (c1 * -1), c1 from dummy;
insert into t11_child select null, (c1 * -1), c1 from dummy;
insert into t11_child select null, (c1 * -1), c1 from dummy;
insert into t11_child select null, (c1 * -1), c1 from dummy;
insert into t11_child select null, (c1 * -1), null from dummy limit 1; /* c1:4001 */
insert into t11_child select null, (c1 * -1), null from dummy limit 1; /* c1:4002 */

select /*+ recompile */
    c.c1,
    c.c2
from
    t11_parent as p
    inner join t11_child as c on c.parent_c1 = p.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t11_child as c,
    t11_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1;
show trace;

drop table if exists t11_child;
drop table if exists t11_parent;
drop table if exists t11_super_parent;


drop table if exists dummy;

set trace off;
