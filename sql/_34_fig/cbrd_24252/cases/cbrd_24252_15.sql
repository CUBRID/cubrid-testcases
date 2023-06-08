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
 * test case 15
 *   - child c (parent_c1:not_null)
 *   - parent__p__p# p (partitioned) (c:parent_c1->p:c1)
 *
 * ---------------------------------------- */

drop table if exists t15_child;
drop table if exists t15_parent;
create table t15_parent (c1 int primary key auto_increment, c2 int)  partition by hash (c1) partitions 4;
create table t15_child (c1 int auto_increment primary key, c2 int);
alter table t15_child add column parent_c1 int not null references t15_parent (c1); /* not_null */
insert into t15_parent select null, c1 from dummy;
insert into t15_child select null, (c1 * -1), c1 from dummy;
insert into t15_child select null, (c1 * -1), c1 from dummy;

select /*+ recompile */
    c.c1,
    c.c2
from
    t15_parent__p__p1 as p
    inner join t15_child as c on c.parent_c1 = p.c1
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t15_child as c,
    t15_parent__p__p1 as p
where
    c.parent_c1 = p.c1
    and c.c2 = -1;
show trace;

drop table if exists t15_child;
drop table if exists t15_parent;


drop table if exists dummy;

set trace off;
