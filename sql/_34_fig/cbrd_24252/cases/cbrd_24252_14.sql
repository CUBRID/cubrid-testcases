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
 * test case 14
 *   - child c (parent_c1:null)
 *   - parent p (partition) (c:parent_c1->p:c1)
 *
 * ---------------------------------------- */

drop table if exists t14_child;
drop table if exists t14_parent;
create table t14_parent (c1 int primary key auto_increment, c2 int)  partition by hash (c1) partitions 4;
create table t14_child (c1 int auto_increment primary key, c2 int);
alter table t14_child add column parent_c1 int references t14_parent (c1); /* null */
insert into t14_parent select null, c1 from dummy;
insert into t14_child select null, (c1 * -1), c1 from dummy;
insert into t14_child select null, (c1 * -1), c1 from dummy;
insert into t14_child select null, (c1 * -1), null from dummy limit 1; /* c1:2001 */

select /*+ recompile */
    c.c1,
    c.c2
from
    t14_parent as p
    inner join t14_child as c on c.parent_c1 = p.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t14_child as c,
    t14_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1;
show trace;

drop table if exists t14_child;
drop table if exists t14_parent;


drop table if exists dummy;

set trace off;
