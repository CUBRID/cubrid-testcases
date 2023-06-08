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
 * test case 23
 *   - child c (parent_col_a:not_null, parent_col_b:not_null)
 *   - parenta pa (c:parenta_col_a->pa:col_a)
 *   - parentb pb (not used)
 *
 * ---------------------------------------- */

drop table if exists t_child;
drop table if exists t_parenta;
drop table if exists t_parentb;
create table t_parenta (col_a int primary key, col_b int);
create table t_parentb (col_a int primary key, col_b int);
create table t_child (col_a int auto_increment primary key, col_b int);
alter table t_child add column parenta_col_a int not null references t_parenta (col_a); /* not_null */
alter table t_child add column parentb_col_a int not null references t_parentb (col_a); /* not_null */
insert into t_parenta select col_a, col_a from dummy;
insert into t_parentb select col_a, col_a from dummy;
insert into t_child select null, (col_a * -1), col_a, col_a from dummy;
insert into t_child select null, (col_a * -1), col_a, col_a from dummy;

/* ansi‑style */
select /*+ recompile */
    c.col_a,
    c.col_b
from
    t_parenta as pa
    inner join t_child as c on c.parenta_col_a = pa.col_a
where
    c.col_b = -1;
show trace;

select /*+ recompile */
    c.col_a,
    c.col_b
from
    t_child as c,
    t_parenta as pa
where
    c.parenta_col_a = pa.col_a
    and c.col_b = -1;
show trace;

drop table if exists t_child;
drop table if exists t_parenta;
drop table if exists t_parentb;



drop table if exists dummy;

set trace off;
