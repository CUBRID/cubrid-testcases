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
 * test case 1
 *   - child c (parent_c1:not_null)
 *   - parent p (c.parent_c1->p.c1)
 *
 * ---------------------------------------- */

drop table if exists t1_child;
drop table if exists t1_parent;
create table t1_parent (c1 int primary key, c2 int);
create table t1_child (c1 int auto_increment primary key, c2 int);
alter table t1_child add column parent_c1 int not null references t1_parent (c1); /* not_null */
insert into t1_parent select c1, c1 from dummy;
insert into t1_child select null, (c1 * -1), c1 from dummy;
insert into t1_child select null, (c1 * -1), c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t1_parent as p
    inner join t1_child as c on c.parent_c1 = p.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t1_child as c,
    t1_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1;
show trace;

drop table if exists t1_child;
drop table if exists t1_parent;


drop table if exists dummy;

set trace off;
