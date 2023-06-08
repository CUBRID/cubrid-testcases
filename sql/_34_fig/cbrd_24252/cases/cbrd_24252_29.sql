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
 * test case 29
 *   - child c (parent_c1:not_null)
 *   - parent p (c1:parent_c1->p:c1)
 *
 * ---------------------------------------- */

drop table if exists t29_child;
drop table if exists t29_parent;
create table t29_parent (c1 int primary key, c2 int);
create table t29_child (c1 int auto_increment primary key, c2 int);
alter table t29_child add column parent_c1 int not null references t29_parent (c1); /* not_null */
insert into t29_parent select c1, c1 from dummy;
insert into t29_child select null, (c1 * -1), c1 from dummy;
insert into t29_child select null, (c1 * -1), c1 from dummy;

select /*+ recompile */
    c.c1,
    c.c2
from
    t29_child as c,
    t29_parent as p
where
    c.parent_c1 = cast(p.c1 as bigint)
    and c.c2 = -1;


drop table if exists t29_child;
drop table if exists t29_parent;



drop table if exists dummy;

set trace off;
