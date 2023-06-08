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
 * test case 24
 *   - child c (parent_c1:not_null, parent_c2:not_null)
 *   - parent1 p1 (not used)
 *   - parent2 p2 (c:parent2_c1->p1:c1)
 *
 * ---------------------------------------- */

drop table if exists t24_child;
drop table if exists t24_parent1;
drop table if exists t24_parent2;
create table t24_parent1 (c1 int primary key, c2 int);
create table t24_parent2 (c1 int primary key, c2 int);
create table t24_child (c1 int auto_increment primary key, c2 int);
alter table t24_child add column parent1_c1 int not null references t24_parent1 (c1); /* not_null */
alter table t24_child add column parent2_c1 int not null references t24_parent2 (c1); /* not_null */
insert into t24_parent1 select c1, c1 from dummy;
insert into t24_parent2 select c1, c1 from dummy;
insert into t24_child select null, (c1 * -1), c1, c1 from dummy;
insert into t24_child select null, (c1 * -1), c1, c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t24_parent2 as p2
    inner join t24_child as c on c.parent2_c1 = p2.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t24_child as c,
    t24_parent2 as p2
where
    c.parent2_c1 = p2.c1
    and c.c2 = -1;
show trace;


drop table if exists t24_child;
drop table if exists t24_parent1;
drop table if exists t24_parent2;



drop table if exists dummy;

set trace off;
