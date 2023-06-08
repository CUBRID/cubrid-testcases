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
 * test case 30
 *   - or predicate
 *
 * ---------------------------------------- */

drop table if exists t30_child;
drop table if exists t30_parent;
create table t30_parent (c1 int primary key, c2 int, c3 int);
create table t30_child (c1 int auto_increment primary key, c2 int, c3 int);
alter table t30_child add column parent_c1 int not null references t30_parent (c1); /* not_null */
insert into t30_parent select c1, c1, c1 from dummy;
insert into t30_child select null, (c1 * -1), c1, c1 from dummy;
insert into t30_child select null, (c1 * -1), c1, c1 from dummy;

select /*+ recompile */
    c.c1,
    c.c2
from
    t30_child as c,
    t30_parent as p
where
    (c.parent_c1 = p.c1 or c.c3 = p.c3)
    and c.c2 = -1;
show trace;

drop table if exists t30_child;
drop table if exists t30_parent;



drop table if exists dummy;

set trace off;
