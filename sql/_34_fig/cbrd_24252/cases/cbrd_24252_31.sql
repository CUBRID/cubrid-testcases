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
 * test case 31
 *   - group by
 *
 * ---------------------------------------- */

drop table if exists t31_child;
drop table if exists t31_parent;
create table t31_parent (c1 int primary key, c2 int);
create table t31_child (c1 int auto_increment primary key, c2 int);
alter table t31_child add column parent_c1 int not null references t31_parent (c1); /* not_null */
insert into t31_parent select c1, c1 from dummy;
insert into t31_child select null, (c1 * -1), c1 from dummy;
insert into t31_child select null, (c1 * -1), c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    max (c.c1),
    max (c.c2)
from
    t31_child as c
    inner join t31_parent as p on c.parent_c1 = p.c1
where
    c.c2 = -1
group by p.c1;
show trace;

select /*+ recompile */
    max (c.c1),
    max (c.c2)
from
    t31_child as c,
    t31_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1
group by p.c1;
show trace;


drop table if exists t31_child;
drop table if exists t31_parent;



drop table if exists dummy;

set trace off;
