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
 * test case 8
 *   - child c (parent_c1:not_null)
 *   - parent p (super_parent_c1:null) (c:parent_c1->p:c1)
 *   - super parent s (p:super_parent_c1->s:c1)
 *
 * ---------------------------------------- */

drop table if exists t8_child;
drop table if exists t8_parent;
drop table if exists t8_super_parent;
create table t8_super_parent (c1 int primary key, c2 int);
create table t8_parent (c1 int primary key auto_increment, c2 int);
alter table t8_parent add column super_parent_c1 int references t8_super_parent (c1); /* null */
create table t8_child (c1 int auto_increment primary key, c2 int);
alter table t8_child add column parent_c1 int not null references t8_parent (c1); /* not_null */
insert into t8_super_parent select c1, c1 from dummy;
insert into t8_parent select null, (c1 * -1), c1 from dummy;
insert into t8_parent select null, (c1 * -1), c1 from dummy;
insert into t8_parent select null, (c1 * -1), null from dummy limit 1; /* c1:2001 */
insert into t8_child select null, (c1 * -1), c1 from dummy;
insert into t8_child select null, (c1 * -1), c1 from dummy;
insert into t8_child select null, (c1 * -1), c1 from dummy;
insert into t8_child select null, (c1 * -1), c1 from dummy;

select /*+ recompile */
    c.c1,
    c.c2
from
    t8_child as c
    inner join t8_parent as p on c.parent_c1 = p.c1
    inner join t8_super_parent as s on p.super_parent_c1 = s.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t8_child as c,
    t8_parent as p,
    t8_super_parent as s
where
    c.parent_c1 = p.c1
    and p.super_parent_c1 = s.c1
    and c.c2 = -1;
show trace;

drop table if exists t8_child;
drop table if exists t8_parent;
drop table if exists t8_super_parent;


drop table if exists dummy;

set trace off;
