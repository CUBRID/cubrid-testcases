-- Verification for CBRD-27478 : Keep the rows of the tables declared ROW_SNAPSHOT with their statistics and price their joins by the keys a filter selects
-- A code table filtered by a constant joins a large table on its key. Histograms are per column, so without the rows
-- the join is priced at 1/NDV whatever key the constant selects. A table declared ROW_SNAPSHOT keeps its rows
-- (none when it has more than statistics_row_snapshot_rows of them) with its statistics, and the
-- optimizer prices the join by the selected key.

drop table if exists t_27478_c;
drop table if exists t_27478_f;
drop table if exists t_27478_g;
drop table if exists t_27478_n;
create table t_27478_c (id int primary key, name varchar(20)) row_snapshot;
create table t_27478_f (c_id int, k int);
create table t_27478_g (k int, v int, pad char(100));
create table t_27478_n (id int primary key, name varchar(20));

insert into t_27478_c values (1, 'common'), (2, 'rare2'), (3, 'rare3'), (4, 'rare4'), (5, 'rare5');
insert into t_27478_n values (1, 'common'), (2, 'rare2'), (3, 'rare3'), (4, 'rare4'), (5, 'rare5');

-- 39000 rows carry code 1, 250 rows each of codes 2 to 5
insert into t_27478_f
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select case when rownum <= 39000 then 1 else 2 + mod (rownum, 4) end, rownum from cte a, cte b where rownum <= 40000;

insert into t_27478_g
with recursive cte (n) as (select 1 union all select n + 1 from cte where n < 200)
select rownum, mod (rownum, 100), 'p' from cte a, cte b where rownum <= 40000;

create index i_27478_f_c on t_27478_f (c_id);
create index i_27478_g_k on t_27478_g (k);

update statistics on t_27478_c, t_27478_f, t_27478_g, t_27478_n with fullscan;

evaluate 'Case 1: the option is part of the schema';
show create table t_27478_c;
show create table t_27478_n;

evaluate 'Case 2: only the declared table keeps its rows';
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

evaluate 'Case 6: an IN list of rare codes is evaluated on the rows too';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name in ('rare2', 'rare3') and f.c_id = c.id and g.k = f.k;

evaluate 'Case 7: a code the rows do not hold keeps the histogram estimate (nested loop, no rows)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'no such code' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 8: a LIKE filter cannot be evaluated on the rows: the histogram estimate stays (nested loop)';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name like 'comm%' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 9: statistics_row_snapshot_rows=0 turns the use off (nested loop)';
set system parameters 'statistics_row_snapshot_rows=0';
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;
set system parameters 'statistics_row_snapshot_rows=10000';

evaluate 'Case 10: NO_ROW_SNAPSHOT drops the rows at once (nested loop)';
alter table t_27478_c no_row_snapshot;
show create table t_27478_c;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 11: ROW_SNAPSHOT again keeps the rows from the next UPDATE STATISTICS (hash join)';
alter table t_27478_c row_snapshot;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;
update statistics on t_27478_c with fullscan;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;
--@queryplan
select /*+ recompile */ count (*) from t_27478_c c, t_27478_f f, t_27478_g g
where c.name = 'common' and f.c_id = c.id and g.k = f.k;

evaluate 'Case 12: a table over statistics_row_snapshot_rows keeps no rows, and gets them back once under it';
set system parameters 'statistics_row_snapshot_rows=3';
update statistics on t_27478_c with fullscan;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;
set system parameters 'statistics_row_snapshot_rows=10000';
update statistics on t_27478_c with fullscan;
select class_name, attr_name from db_histogram where class_name = 't_27478_c' order by attr_name;

evaluate 'Case 13: CREATE TABLE LIKE copies the option';
drop table if exists t_27478_l;
create table t_27478_l like t_27478_c;
show create table t_27478_l;
drop table t_27478_l;

evaluate 'Case 14: not for views, partitioned tables or a class in an inheritance chain, and not twice';
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

evaluate 'Case 15: dropping the table leaves no kept rows behind';
select count (*) from _db_histogram where key_attr = '.row_snapshot';
drop table t_27478_c;
select count (*) from _db_histogram where key_attr = '.row_snapshot';

drop table t_27478_f;
drop table t_27478_g;
drop table t_27478_n;
