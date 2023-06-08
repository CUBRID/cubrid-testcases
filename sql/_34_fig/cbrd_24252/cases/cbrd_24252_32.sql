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
 * test case 32
 *   - union all
 *
 * ---------------------------------------- */

drop table if exists t32_other;
drop table if exists t32_child;
drop table if exists t32_parent;
create table t32_parent (c1 int primary key, c2 int);
create table t32_child (c1 int auto_increment primary key, c2 int);
create table t32_other (c1 int auto_increment primary key, c2 int);
alter table t32_child add column parent_c1 int not null references t32_parent (c1); /* not_null */
insert into t32_parent select c1, c1 from dummy;
insert into t32_child select null, (c1 * -1), c1 from dummy;
insert into t32_child select null, (c1 * -1), c1 from dummy;
insert into t32_other select null, c1 + 10000 from dummy;

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t32_child as c
    inner join t32_parent as p on c.parent_c1 = p.c1
where
    c.c2 = -1
union all
select /*+ recompile */
    o.c1,
    o.c2
from
    t32_other as o
where
    o.c2 = 10001;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t32_child as c,
    t32_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1
union all
select /*+ recompile */
    o.c1,
    o.c2
from
    t32_other as o
where
    o.c2 = 10001;
show trace;

drop table if exists t32_other;
drop table if exists t32_child;
drop table if exists t32_parent;



drop table if exists dummy;

set trace off;
