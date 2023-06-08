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
 * test case 33
 *   - NO_ELIMINATE_JOIN
 *
 * ---------------------------------------- */

drop table if exists t33_child;
drop table if exists t33_parent;
create table t33_parent (c1 int primary key, c2 int);
create table t33_child (c1 int auto_increment primary key, c2 int);
alter table t33_child add column parent_c1 int not null references t33_parent (c1); /* not_null */
insert into t33_parent select c1, c1 from dummy;
insert into t33_child select null, (c1 * -1), c1 from dummy;
insert into t33_child select null, (c1 * -1), c1 from dummy;

/* ansi‑style */
select /*+ recompile no_eliminate_join */
    c.c1,
    c.c2
from
    t33_parent as p
    inner join t33_child as c on c.parent_c1 = p.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile no_eliminate_join */
    c.c1,
    c.c2
from
    t33_child as c,
    t33_parent as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1;
show trace;

drop table if exists t1_child;
drop table if exists t1_parent;



drop table if exists dummy;

set trace off;
