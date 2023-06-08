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
 * test case 22
 *   - child c (parent_c1:null, parent_c2:null)
 *   - parent1 p1 (c:parent1_c1->p1:c1)
 *   - parent2 p2 (c:parent2_c1->p2:c1)
 *
 * ---------------------------------------- */

drop table if exists t22_child;
drop table if exists t22_parent1;
drop table if exists t22_parent2;
create table t22_parent1 (c1 int primary key, c2 int);
create table t22_parent2 (c1 int primary key, c2 int);
create table t22_child (c1 int auto_increment primary key, c2 int);
alter table t22_child add column parent1_c1 int references t22_parent1 (c1); /* null */
alter table t22_child add column parent2_c1 int references t22_parent2 (c1); /* null */
insert into t22_parent1 select c1, c1 from dummy;
insert into t22_parent2 select c1, c1 from dummy;
insert into t22_child select null, (c1 * -1), c1, c1 from dummy;
insert into t22_child select null, (c1 * -1), c1, c1 from dummy;
insert into t22_child select null, (c1 * -1), null, null from dummy limit 1; /* c1:2001 */

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t22_child as c
    inner join t22_parent1 as p1 on c.parent1_c1 = p1.c1
    inner join t22_parent2 as p2 on c.parent2_c1 = p2.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t22_child as c,
    t22_parent1 as p1,
    t22_parent2 as p2
where
    c.parent1_c1 = p1.c1
    and c.parent2_c1 = p2.c1
    and c.c2 = -1;
show trace;

drop table if exists t22_child;
drop table if exists t22_parent1;
drop table if exists t22_parent2;



drop table if exists dummy;

set trace off;
