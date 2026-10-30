-- Verification for CBRD-27478 : Read the rows a constant filter selects while planning and price the equi-joins by their keys
-- A code table filtered by a constant joins a large table on its key. Histograms are per column, so without the rows
-- the join is priced at 1/NDV whatever key the constant selects. For a node joined by an equality, the optimizer
-- reads the rows its constant filters select from the table while it plans (through an index on a filter column,
-- at most row_snapshot_max_rows of them; hinted ROW_SNAPSHOT, also a table the statistics count at most 1000 rows
-- without the index) and prices the join by their keys.

drop table if exists t_27478_c;
drop table if exists t_27478_f;
drop table if exists t_27478_g;
drop table if exists t_27478_x;
create table t_27478_c (id int primary key, name varchar(20));
create table t_27478_f (c_id int, k int);
create table t_27478_g (k int, v int, pad char(100));
create table t_27478_x (id int primary key, name varchar(20));

insert into t_27478_c values (1, 'common'), (2, 'rare2'), (3, 'rare3'), (4, 'rare4'), (5, 'rare5');
insert into t_27478_x select * from t_27478_c;

-- 39000 rows carry code 1, 250 rows each of codes 2 to 5
insert into t_27478_f
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select case when rownum <= 39000 then 1 else 2 + mod (rownum, 4) end, rownum from cte a, cte b where rownum <= 40000;

insert into t_27478_g
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select rownum, mod (rownum, 100), 'p' from cte a, cte b where rownum <= 40000;

-- the filter column of t_27478_c has an index, that of t_27478_x has none
create index i_27478_c_name on t_27478_c (name);
create index i_27478_f_c on t_27478_f (c_id);
create index i_27478_g_k on t_27478_g (k);

update statistics on t_27478_c, t_27478_f, t_27478_g, t_27478_x with fullscan;

evaluate 'Case 1: the common code selects 39000 rows: hash join with t_27478_g';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 2: row_snapshot_max_rows=0 turns the reading off: the join is priced at 1/NDV (nested loop)';
set system parameters 'row_snapshot_max_rows=0';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
set system parameters 'row_snapshot_max_rows=100';

evaluate 'Case 3: a rare code selects 250 rows: index nested loop into t_27478_g';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'rare2' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 4: an IN list of rare codes is read too';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('rare2', 'rare3') and f.c_id = c.id and g.k = f.k;

evaluate 'Case 5: a code the table does not hold keeps the histogram estimate (nested loop, no rows)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'no such code' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 6: a LIKE filter is not read: the histogram estimate stays (nested loop)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name like 'comm%' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 7: no index on the filter column: the table is not read (nested loop)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_x c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 8: a filter that selects more than row_snapshot_max_rows rows keeps the histogram estimate';
set system parameters 'row_snapshot_max_rows=1';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('common', 'rare2') and f.c_id = c.id and g.k = f.k;
set system parameters 'row_snapshot_max_rows=100';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('common', 'rare2') and f.c_id = c.id and g.k = f.k;

evaluate 'Case 9: the rows are read as they are now: a code renamed after UPDATE STATISTICS is found (hash join)';
update t_27478_c set name = 'renamed' where id = 1;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'renamed' and f.c_id = c.id and g.k = f.k;
update t_27478_c set name = 'common' where id = 1;

evaluate 'Case 10: the NO_ROW_SNAPSHOT hint turns the reading off for the statement (nested loop)';
--@queryplan
select /*+ recompile no_row_snapshot */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 11: the ROW_SNAPSHOT hint reads the rows even with row_snapshot_max_rows=0 (hash join)';
set system parameters 'row_snapshot_max_rows=0';
--@queryplan
select /*+ recompile row_snapshot */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
set system parameters 'row_snapshot_max_rows=100';

evaluate 'Case 12: nothing is stored with the statistics';
select class_name, attr_name from db_histogram where class_name like 't_27478_%' order by class_name, attr_name;

evaluate 'Case 13: hinted ROW_SNAPSHOT, a table the statistics count as small is read without an index (hash join)';
--@queryplan
select /*+ recompile row_snapshot */ count (*) from t_27478_x c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 14: hinted ROW_SNAPSHOT, a table the statistics count past 1000 rows is not read without an index (nested loop)';
create table t_27478_y (id int primary key, name varchar(20));
insert into t_27478_y
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 100)
select rownum, case when rownum = 1 then 'common' else 'code' || rownum end from cte a, cte b where rownum <= 2000;
update statistics on t_27478_y with fullscan;
--@queryplan
select /*+ recompile row_snapshot */ count (*) from t_27478_y c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
drop table t_27478_y;

drop table t_27478_c;
drop table t_27478_f;
drop table t_27478_g;
drop table t_27478_x;
