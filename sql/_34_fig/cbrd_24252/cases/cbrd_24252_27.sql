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
 * test case 27
 *   - child c (parent_c1:not_null)
 *   - parent p (c1:parent_c1->p:parent_c1)
 *
 * ---------------------------------------- */

drop table if exists t27_child;
drop table if exists t27_parent;
create table t27_parent (parent_c1 int primary key, parent_c2 int);
create table t27_child (c1 int auto_increment primary key, c2 int);
alter table t27_child add column parent_c1 int not null references t27_parent (parent_c1); /* not_null */
insert into t27_parent select c1, c1 from dummy;
insert into t27_child select null, (c1 * -1), c1 from dummy;
insert into t27_child select null, (c1 * -1), c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t27_parent as p
    natural join t27_child as c 
where
    c.c2 = -1;
show trace;

drop table if exists t27_child;
drop table if exists t27_parent;



drop table if exists dummy;

set trace off;
