set trace on;

/* dummy data */
drop table if exists dummy;
create table dummy (col_a int);
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

drop table if exists t_child;
drop table if exists t_parent;
create table t_parent (col_a int primary key, col_b int);
create table t_child (col_a int auto_increment primary key, col_b int);
alter table t_child add column parent_col_a int not null references t_parent (col_a); /* not_null */
insert into t_parent select col_a, col_a from dummy;
insert into t_child select null, (col_a * -1), col_a from dummy;
insert into t_child select null, (col_a * -1), col_a from dummy;

/* ansi‑style */
select /*+ recompile */
    max (c.col_a),
    max (c.col_b)
from
    t_child as c
    inner join t_parent as p on c.parent_col_a = p.col_a
where
    c.col_b = -1
group by p.col_a;
show trace;

select /*+ recompile */
    max (c.col_a),
    max (c.col_b)
from
    t_child as c,
    t_parent as p
where
    c.parent_col_a = p.col_a
    and c.col_b = -1
group by p.col_a;
show trace;


drop table if exists t_child;
drop table if exists t_parent;



drop table if exists dummy;

set trace off;
