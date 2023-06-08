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
 * test case 28
 *   - child c (parent_c1:null)
 *   - parent p (c1:parent_c1->p:parent_c1)
 *
 * ---------------------------------------- */

drop table if exists t28_child;
drop table if exists t28_parent;
create table t28_parent (parent_c1 int primary key, parent_c2 int);
create table t28_child (c1 int auto_increment primary key, c2 int);
alter table t28_child add column parent_c1 int references t28_parent (parent_c1); /* null */
insert into t28_parent select c1, c1 from dummy;
insert into t28_child select null, (c1 * -1), c1 from dummy;
insert into t28_child select null, (c1 * -1), c1 from dummy;
insert into t28_child select null, (c1 * -1), null from dummy limit 1; /* c1:2001 */

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t28_parent as p
    natural join t28_child as c 
where
    c.c2 = -1;
show trace;

drop table if exists t28_child;
drop table if exists t28_parent;



drop table if exists dummy;

set trace off;
