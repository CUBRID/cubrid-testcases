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
 * test case 23
 *   - child c (parent_c1:not_null, parent_c2:not_null)
 *   - parent1 p1 (c:parent1_c1->p1:c1)
 *   - parent2 p2 (not used)
 *
 * ---------------------------------------- */

drop table if exists t23_child;
drop table if exists t23_parent1;
drop table if exists t23_parent2;
create table t23_parent1 (c1 int primary key, c2 int);
create table t23_parent2 (c1 int primary key, c2 int);
create table t23_child (c1 int auto_increment primary key, c2 int);
alter table t23_child add column parent1_c1 int not null references t23_parent1 (c1); /* not_null */
alter table t23_child add column parent2_c1 int not null references t23_parent2 (c1); /* not_null */
insert into t23_parent1 select c1, c1 from dummy;
insert into t23_parent2 select c1, c1 from dummy;
insert into t23_child select null, (c1 * -1), c1, c1 from dummy;
insert into t23_child select null, (c1 * -1), c1, c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t23_parent1 as p1
    inner join t23_child as c on c.parent1_c1 = p1.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t23_child as c,
    t23_parent1 as p1
where
    c.parent1_c1 = p1.c1
    and c.c2 = -1;
show trace;

drop table if exists t23_child;
drop table if exists t23_parent1;
drop table if exists t23_parent2;



drop table if exists dummy;

set trace off;
