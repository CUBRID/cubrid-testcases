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
 * test case 4
 *   - child c (parent_c1:null)
 *   - parent p1 (c:parent_c1->p1:c1)
 *   - parent p2 (c:parent_c1->p2:c1)
 *
 * ---------------------------------------- */

drop table if exists t4_child;
drop table if exists t4_parent;
create table t4_parent (c1 int primary key, c2 int);
create table t4_child (c1 int auto_increment primary key, c2 int);
alter table t4_child add column parent_c1 int references t4_parent (c1); /* null */
insert into t4_parent select c1, c1 from dummy;
insert into t4_child select null, (c1 * -1), c1 from dummy;
insert into t4_child select null, (c1 * -1), c1 from dummy;
insert into t4_child select null, (c1 * -1), null from dummy limit 1; /* c1:2001 */

select /*+ recompile */
    c.c1,
    c.c2
from
    t4_child as c
    inner join t4_parent as p1 on c.parent_c1 = p1.c1
    inner join t4_parent as p2 on c.parent_c1 = p2.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t4_child as c,
    t4_parent as p1,
    t4_parent as p2
where
    c.parent_c1 = p1.c1
    and c.parent_c1 = p2.c1
    and c.c2 = -1;
show trace;

drop table if exists t4_child;
drop table if exists t4_parent;


drop table if exists dummy;

set trace off;
