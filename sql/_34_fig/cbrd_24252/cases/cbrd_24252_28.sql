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
 * test case 28
 *   - child c (parent_col_a:null)
 *   - parent p (col_a:parent_col_a->p:parent_col_a)
 *
 * ---------------------------------------- */

drop table if exists t_child;
drop table if exists t_parent;
create table t_parent (parent_col_a int primary key, parent_col_b int);
create table t_child (col_a int auto_increment primary key, col_b int);
alter table t_child add column parent_col_a int references t_parent (parent_col_a); /* null */
insert into t_parent select col_a, col_a from dummy;
insert into t_child select null, (col_a * -1), col_a from dummy;
insert into t_child select null, (col_a * -1), col_a from dummy;
insert into t_child select null, (col_a * -1), null from dummy limit 1; /* col_a:2001 */

update statistics on t_child with fullscan;
update statistics on t_parent with fullscan;

/* ansi‑style */
select /*+ recompile */
    c.col_a,
    c.col_b
from
    t_parent as p
    natural join t_child as c 
where
    c.col_b = -1;
show trace;

drop table if exists t_child;
drop table if exists t_parent;



drop table if exists dummy;

set trace off;
