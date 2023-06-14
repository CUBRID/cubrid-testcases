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
 * test case 25
 *   - childa ca (parent_col_a:not_null)
 *   - childb cb (parent_col_a:not_null) (not used)
 *   - parent p (col_a:parent_col_a->p:col_a)
 *
 * ---------------------------------------- */

drop table if exists t_childa;
drop table if exists t_childb;
drop table if exists t_parent;
create table t_parent (col_a int primary key, col_b int);
create table t_childa (col_a int auto_increment primary key, col_b int);
alter table t_childa add column parent_col_a int not null references t_parent (col_a); /* not_null */
create table t_childb (col_a int auto_increment primary key, col_b int);
alter table t_childb add column parent_col_a int not null references t_parent (col_a); /* not_null */
insert into t_parent select col_a, col_a from dummy;
insert into t_childa select null, (col_a * -1), col_a from dummy;
insert into t_childa select null, (col_a * -1), col_a from dummy;
insert into t_childb select null, (col_a * -1), col_a from dummy;
insert into t_childb select null, (col_a * -1), col_a from dummy;

update statistics on t_childa with fullscan;
update statistics on t_childb with fullscan;
update statistics on t_parent with fullscan;

/* ansi‑style */
select /*+ recompile */
    ca.col_a,
    ca.col_b
from
    t_parent as p
    inner join t_childa as ca on ca.parent_col_a = p.col_a
where
    ca.col_b = -1;
show trace;

select /*+ recompile */
    ca.col_a,
    ca.col_b
from
    t_childa as ca,
    t_parent as p
where
    ca.parent_col_a = p.col_a
    and ca.col_b = -1;
show trace;

drop table if exists t_childa;
drop table if exists t_childb;
drop table if exists t_parent;



drop table if exists dummy;

set trace off;
