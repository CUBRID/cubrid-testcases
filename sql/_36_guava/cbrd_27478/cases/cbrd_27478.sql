-- Verification for CBRD-27478 : Keep the rows of small tables with their statistics and price their joins by the keys a filter selects
-- A code table filtered by a constant joins a large table on its key. Histograms are per column, so without the rows
-- the join is priced at 1/NDV whatever key the constant selects. With statistics_row_snapshot_max_rows set,
-- UPDATE STATISTICS keeps the rows of a table that small, and the optimizer prices the join by the selected key.

drop table if exists t_27478_c;
drop table if exists t_27478_f;
drop table if exists t_27478_g;
create table t_27478_c (id int primary key, name varchar(20));
create table t_27478_f (c_id int, k int);
create table t_27478_g (k int, v int, pad char(100));

insert into t_27478_c values (1, 'common'), (2, 'rare2'), (3, 'rare3'), (4, 'rare4'), (5, 'rare5');

-- 39000 rows carry code 1, 250 rows each of codes 2 to 5
insert into t_27478_f
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select case when rownum <= 39000 then 1 else 2 + mod (rownum, 4) end, rownum from cte a, cte b where rownum <= 40000;

insert into t_27478_g
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select rownum, mod (rownum, 100), 'p' from cte a, cte b where rownum <= 40000;

create index i_27478_f_c on t_27478_f (c_id);
create index i_27478_g_k on t_27478_g (k);

set system parameters 'statistics_row_snapshot_max_rows=1000';
update statistics on t_27478_c, t_27478_f, t_27478_g with fullscan;

evaluate 'Case 1: the five-row code table keeps its rows, the large tables do not';
select class_name, attr_name from db_histogram where class_name like 't_27478_%' order by class_name, attr_name;

evaluate 'Case 2: the common code selects 39000 rows: hash join with t_27478_g';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 3: a rare code selects 250 rows: index nested loop into t_27478_g';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'rare2' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 4: an IN list of rare codes is evaluated on the rows too';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('rare2', 'rare3') and f.c_id = c.id and g.k = f.k;

evaluate 'Case 5: a code the rows do not hold keeps the histogram estimate (nested loop, no rows)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'no such code' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 6: a LIKE filter cannot be evaluated on the rows: the histogram estimate stays (nested loop)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name like 'comm%' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 7: the parameter at 0 turns the use off: the common code is priced at 1/NDV again (nested loop)';
set system parameters 'statistics_row_snapshot_max_rows=0';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
set system parameters 'statistics_row_snapshot_max_rows=1000';

evaluate 'Case 8: dropping the histograms drops the rows as well';
update statistics on t_27478_c with drop histogram;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 9: a table over the limit keeps no rows';
set system parameters 'statistics_row_snapshot_max_rows=3';
update statistics on t_27478_c with fullscan;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;

evaluate 'Case 10: collected again under the limit, then the table is dropped: no row is left behind';
set system parameters 'statistics_row_snapshot_max_rows=1000';
update statistics on t_27478_c with fullscan;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;
select count (*) from _db_histogram where key_attr = '.row_snapshot';
drop table t_27478_c;
select count (*) from _db_histogram where key_attr = '.row_snapshot';

set system parameters 'statistics_row_snapshot_max_rows=0';
drop table t_27478_f;
drop table t_27478_g;
