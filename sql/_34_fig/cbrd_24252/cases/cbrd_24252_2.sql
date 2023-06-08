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
 * test case 2
 *   - child c (parent_c1:null)
 *   - parent p (c.parent_c1->p.c1)
 *
 * ---------------------------------------- */

drop table if exists t2_child;
drop table if exists t2_parent;
create table t2_parent (c1 int primary key, c2 int);
create table t2_child (c1 int auto_increment primary key, c2 int);
alter table t2_child add column parent_c1 int references t2_parent (c1); /* null */
insert into t2_parent select c1, c1 from dummy;
insert into t2_child select null, (c1 * -1), c1 from dummy;
insert into t2_child select null, (c1 * -1), c1 from dummy;
insert into t2_child select null, (c1 * -1), null from dummy limit 1; /* c1:2001 */

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t2_parent as p
    inner join t2_child as c on c.parent_c1 = p.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t2_child as c,
    t2_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1;
show trace;

drop table if exists t2_child;
drop table if exists t2_parent;


drop table if exists dummy;

set trace off;
