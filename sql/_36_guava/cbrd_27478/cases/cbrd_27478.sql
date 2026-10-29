-- Verification for CBRD-27478 : Read the rows a constant filter selects from the tables declared ROW_SNAPSHOT while planning and price their joins by those keys
-- A code table filtered by a constant joins a large table on its key. Histograms are per column, so without the rows
-- the join is priced at 1/NDV whatever key the constant selects. For a table declared ROW_SNAPSHOT the optimizer
-- reads the rows the filter selects from the table while it plans (through an index on a filter column, or by a
-- scan of a table no larger than row_snapshot_max_rows; at most that many rows) and prices the join by their keys.

drop table if exists t_27478_c;
drop table if exists t_27478_f;
drop table if exists t_27478_g;
drop table if exists t_27478_n;
drop table if exists t_27478_x;
create table t_27478_c (id int primary key, name varchar(20)) row_snapshot;
create table t_27478_f (c_id int, k int);
create table t_27478_g (k int, v int, pad char(100));
create table t_27478_n (id int primary key, name varchar(20));
create table t_27478_x (id int primary key, name varchar(20)) row_snapshot;

insert into t_27478_c values (1, 'common'), (2, 'rare2'), (3, 'rare3'), (4, 'rare4'), (5, 'rare5');
insert into t_27478_n select * from t_27478_c;
insert into t_27478_x select * from t_27478_c;

-- 39000 rows carry code 1, 250 rows each of codes 2 to 5
insert into t_27478_f
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select case when rownum <= 39000 then 1 else 2 + mod (rownum, 4) end, rownum from cte a, cte b where rownum <= 40000;

insert into t_27478_g
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select rownum, mod (rownum, 100), 'p' from cte a, cte b where rownum <= 40000;

-- the filter column of t_27478_c and t_27478_n has an index, that of t_27478_x has none
create index i_27478_c_name on t_27478_c (name);
create index i_27478_n_name on t_27478_n (name);
create index i_27478_f_c on t_27478_f (c_id);
create index i_27478_g_k on t_27478_g (k);

update statistics on t_27478_c, t_27478_f, t_27478_g, t_27478_n, t_27478_x with fullscan;

evaluate 'Case 1: the option is part of the schema';
show create table t_27478_c;
show create table t_27478_n;

evaluate 'Case 2: nothing but the declaration is stored';
select class_name, attr_name from db_histogram where class_name like 't_27478_%' order by class_name, attr_name;

evaluate 'Case 3: the common code selects 39000 rows: hash join with t_27478_g';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 4: the same query over the undeclared copy is priced at 1/NDV: nested loop';
--@queryplan
select /*+ recompile */ count (*) from t_27478_n c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 5: a rare code selects 250 rows: index nested loop into t_27478_g';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'rare2' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 6: an IN list of rare codes is read too';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('rare2', 'rare3') and f.c_id = c.id and g.k = f.k;

evaluate 'Case 7: a code the table does not hold keeps the histogram estimate (nested loop, no rows)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'no such code' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 8: a LIKE filter is not read: the histogram estimate stays (nested loop)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name like 'comm%' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 9: row_snapshot_max_rows=0 turns the reading off (nested loop)';
set system parameters 'row_snapshot_max_rows=0';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
set system parameters 'row_snapshot_max_rows=1000';

evaluate 'Case 10: no index on the filter column: a table no larger than row_snapshot_max_rows is scanned (hash join), a larger one is not read (nested loop)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_x c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
set system parameters 'row_snapshot_max_rows=4';
--@queryplan
select /*+ recompile */ count (*) from t_27478_x c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
set system parameters 'row_snapshot_max_rows=1000';

evaluate 'Case 11: a filter that selects more than row_snapshot_max_rows rows keeps the histogram estimate';
set system parameters 'row_snapshot_max_rows=1';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('common', 'rare2') and f.c_id = c.id and g.k = f.k;
set system parameters 'row_snapshot_max_rows=1000';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('common', 'rare2') and f.c_id = c.id and g.k = f.k;

evaluate 'Case 12: the rows are read as they are now: a code renamed after UPDATE STATISTICS is found (hash join)';
update t_27478_c set name = 'renamed' where id = 1;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'renamed' and f.c_id = c.id and g.k = f.k;
update t_27478_c set name = 'common' where id = 1;

evaluate 'Case 13: NO_ROW_SNAPSHOT stops the reading at once (nested loop), ROW_SNAPSHOT starts it at once (hash join)';
alter table t_27478_c no_row_snapshot;
show create table t_27478_c;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
alter table t_27478_c row_snapshot;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 14: CREATE TABLE LIKE copies the option';
drop table if exists t_27478_l;
create table t_27478_l like t_27478_c;
show create table t_27478_l;
drop table t_27478_l;

evaluate 'Case 15: not for views, partitioned tables or a class in an inheritance chain, and not twice';
drop view if exists v_27478;
drop table if exists t_27478_p;
drop table if exists t_27478_s;
create view v_27478 as select * from t_27478_c;
alter view v_27478 row_snapshot;
create table t_27478_p (a int) row_snapshot partition by hash (a) partitions 2;
create table t_27478_p (a int) partition by hash (a) partitions 2;
alter table t_27478_p row_snapshot;
create table t_27478_s under t_27478_n (b int);
alter table t_27478_s row_snapshot;
create table t_27478_d (a int) row_snapshot no_row_snapshot;
drop table t_27478_s;
drop table t_27478_p;
drop view v_27478;

drop table t_27478_c;
drop table t_27478_f;
drop table t_27478_g;
drop table t_27478_n;
drop table t_27478_x;
