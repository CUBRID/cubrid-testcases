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
 * test case 34
 *   - child c (parent_c1:not_null, parent_c2:not_null)
 *   - parent p (c:parent_c1->p:c1, c:parent_c2->p:c2)
 *
 * ---------------------------------------- */

drop table if exists t34_child;
drop table if exists t34_parent;
create table t34_parent (c1 int, c2 int, c3 int, primary key (c2, c1));
create table t34_child (c1 int auto_increment primary key, c2 int);
alter table t34_child add column parent_c1 int not null; /* not null */
alter table t34_child add column parent_c2 int not null; /* not null */
alter table t34_child add constraint foreign key (parent_c1, parent_c2) references t34_parent (c1, c2);
insert into t34_parent select c1, c1, c1 from dummy;
insert into t34_child select null, (c1 * -1), c1, c1 from dummy;
insert into t34_child select null, (c1 * -1), c1, c1 from dummy;

/* ansi‑style */
select /*+ recompile */
    c.c1,
    c.c2
from
    t34_parent as p
    inner join t34_child as c on c.parent_c1 = p.c1 and c.parent_c2 =  p.c2
where
    c.c2 = -1;
show trace;

select /*+ recompile */
    c.c1,
    c.c2
from
    t34_child as c,
    t34_parent as p
where
    c.parent_c1 = p.c1
    and c.parent_c2 = p.c2
    and c.c2 = -1;
show trace;

drop table if exists t34_child;
drop table if exists t34_parent;



drop table if exists dummy;

set trace off;
