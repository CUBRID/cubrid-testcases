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
 * test case 26
 *   - child1 c1 (parent_c1:not_null) (not used)
 *   - child2 c2 (parent_c1:not_null)
 *   - parent p (c1:parent_c1->p:c1)
 *
 * ---------------------------------------- */

drop table if exists t26_child1;
drop table if exists t26_child2;
drop table if exists t26_parent;
create table t26_parent (c1 int primary key, c2 int);
create table t26_child1 (c1 int auto_increment primary key, c2 int);
alter table t26_child1 add column parent_c1 int not null references t26_parent (c1); /* not_null */
create table t26_child2 (c1 int auto_increment primary key, c2 int);
alter table t26_child2 add column parent_c1 int not null references t26_parent (c1); /* not_null */
insert into t26_parent select c1, c1 from dummy;
insert into t26_child1 select null, (c1 * -1), c1 from dummy;
insert into t26_child1 select null, (c1 * -1), c1 from dummy;
insert into t26_child2 select null, (c1 * -1), c1 from dummy;
insert into t26_child2 select null, (c1 * -1), c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    c2.c1,
    c2.c2
from
    t26_parent as p
    inner join t26_child2 as c2 on c2.parent_c1 = p.c1
where
    c2.c2 = -1;
show trace;

select /*+ recompile */
    c2.c1,
    c2.c2
from
    t26_child2 as c2,
    t26_parent as p
where
    c2.parent_c1 = p.c1
    and c2.c2 = -1;
show trace;


drop table if exists t26_child1;
drop table if exists t26_child2;
drop table if exists t26_parent;



drop table if exists dummy;

set trace off;
