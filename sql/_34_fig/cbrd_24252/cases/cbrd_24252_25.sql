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
 * test case 25
 *   - child1 c1 (parent_c1:not_null)
 *   - child2 c2 (parent_c1:not_null) (not used)
 *   - parent p (c1:parent_c1->p:c1)
 *
 * ---------------------------------------- */

drop table if exists t25_child1;
drop table if exists t25_child2;
drop table if exists t25_parent;
create table t25_parent (c1 int primary key, c2 int);
create table t25_child1 (c1 int auto_increment primary key, c2 int);
alter table t25_child1 add column parent_c1 int not null references t25_parent (c1); /* not_null */
create table t25_child2 (c1 int auto_increment primary key, c2 int);
alter table t25_child2 add column parent_c1 int not null references t25_parent (c1); /* not_null */
insert into t25_parent select c1, c1 from dummy;
insert into t25_child1 select null, (c1 * -1), c1 from dummy;
insert into t25_child1 select null, (c1 * -1), c1 from dummy;
insert into t25_child2 select null, (c1 * -1), c1 from dummy;
insert into t25_child2 select null, (c1 * -1), c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    c1.c1,
    c1.c2
from
    t25_parent as p
    inner join t25_child1 as c1 on c1.parent_c1 = p.c1
where
    c1.c2 = -1;
show trace;

select /*+ recompile */
    c1.c1,
    c1.c2
from
    t25_child1 as c1,
    t25_parent as p
where
    c1.parent_c1 = p.c1
    and c1.c2 = -1;
show trace;

drop table if exists t25_child1;
drop table if exists t25_child2;
drop table if exists t25_parent;



drop table if exists dummy;

set trace off;
