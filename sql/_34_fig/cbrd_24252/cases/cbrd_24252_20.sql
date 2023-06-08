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
 * test case 20
 *   - child c (parent_c1:null, parent_c2:null)
 *   - parent p (c:parent_c1->p:c1, c:parent_c2->p:c2)
 *
 * ---------------------------------------- */

drop table if exists t20_child;
drop table if exists t20_parent;
create table t20_parent (c1 int, c2 int, c3 int, primary key (c1, c2));
create table t20_child (c1 int auto_increment primary key, c2 int);
alter table t20_child add column parent_c1 int; /* null */
alter table t20_child add column parent_c2 int; /* null */
alter table t20_child add constraint foreign key (parent_c1, parent_c2) references t20_parent (c1, c2);
insert into t20_parent select c1, c1, c1 from dummy;
insert into t20_child select null, (c1 * -1), c1, c1 from dummy;
insert into t20_child select null, (c1 * -1), c1, c1 from dummy;
insert into t20_child select null, (c1 * -1), null, null from dummy limit 1; /* c1:2001 */

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t20_parent as p
    inner join t20_child as c on c.parent_c1 = p.c1 and c.parent_c2 =  p.c2
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t20_child as c,
    t20_parent as p
where
    c.parent_c1 = p.c1
    and c.parent_c2 = p.c2
    and c.c2 = -1;
show trace;

drop table if exists t20_child;
drop table if exists t20_parent;

drop table if exists dummy;

set trace off;
