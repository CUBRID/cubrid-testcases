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
 * test case 5
 *   - child c (parent_c1:not_null)
 *   - parent p1 (c:parent_c1->p1:c1)
 *   - parent p2 (p1:c1->p2:c1)
 *
 * ---------------------------------------- */

drop table if exists t5_child;
drop table if exists t5_parent;
create table t5_parent (c1 int primary key, c2 int);
create table t5_child (c1 int auto_increment primary key, c2 int);
alter table t5_child add column parent_c1 int not null references t5_parent (c1); /* not_null */
insert into t5_parent select c1, c1 from dummy;
insert into t5_child select null, (c1 * -1), c1 from dummy;
insert into t5_child select null, (c1 * -1), c1 from dummy;

select /*+ recompile */
    c.c1,
    c.c2
from
    t5_child as c
    inner join t5_parent as p1 on c.parent_c1 = p1.c1
    inner join t5_parent as p2 on p1.c1 = p2.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t5_child as c,
    t5_parent as p1,
    t5_parent as p2
where
    c.parent_c1 = p1.c1
    and p1.c1 = p2.c1
    and c.c2 = -1;
show trace;

drop table if exists t5_child;
drop table if exists t5_parent;


drop table if exists dummy;

set trace off;
