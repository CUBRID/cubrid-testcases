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
 * test case 9
 *   - child c (parent_c1:null)
 *   - parent p (super_parent_c1:not_null) (c:parent_c1->p:c1)
 *   - super parent s (p:super_parent_c1->s:c1)
 *
 * ---------------------------------------- */

drop table if exists t9_child;
drop table if exists t9_parent;
drop table if exists t9_super_parent;
create table t9_super_parent (c1 int primary key, c2 int);
create table t9_parent (c1 int primary key auto_increment, c2 int);
alter table t9_parent add column super_parent_c1 int not null references t9_super_parent (c1); /* not_null */
create table t9_child (c1 int auto_increment primary key, c2 int);
alter table t9_child add column parent_c1 int references t9_parent (c1); /* null */
insert into t9_super_parent select c1, c1 from dummy;
insert into t9_parent select null, (c1 * -1), c1 from dummy;
insert into t9_parent select null, (c1 * -1), c1 from dummy;
insert into t9_child select null, (c1 * -1), c1 from dummy;
insert into t9_child select null, (c1 * -1), c1 from dummy;
insert into t9_child select null, (c1 * -1), c1 from dummy;
insert into t9_child select null, (c1 * -1), c1 from dummy;
insert into t9_child select null, (c1 * -1), null from dummy limit 1; /* c1:4001 */
insert into t9_child select null, (c1 * -1), null from dummy limit 1; /* c1:4002 */

select /*+ recompile */
    c.c1,
    c.c2
from
    t9_child as c
    inner join t9_parent as p on c.parent_c1 = p.c1
    inner join t9_super_parent as s on p.super_parent_c1 = s.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t9_child as c,
    t9_parent as p,
    t9_super_parent as s
where
    c.parent_c1 = p.c1
    and p.super_parent_c1 = s.c1
    and c.c2 = -1;
show trace;

drop table if exists t9_child;
drop table if exists t9_parent;
drop table if exists t9_super_parent;


drop table if exists dummy;

set trace off;
