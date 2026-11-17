-- CBRD-27381: the index build sorts each in-memory run by radix when the key has a radix key
--
-- index_sort_method picks the in-memory run sorter of an index build, for the session: auto (the
-- default of debug builds) and radix take the radix sorter when the key domain has a radix key,
-- compare (the default of release builds) keeps the merge sort. Whichever sorts the runs, the index
-- must hold the same keys in the same order.
--
-- 6000 rows in four shapes of 1500 (scattered, ascending, descending, few distinct values) and a NULL
-- every 101st row. index_build_buffer_size 64K splits each build into several runs.
--
-- Covers:
--   - the values auto, radix, compare and DEFAULT, a keyword in another case, and bad values
--   - the same rows indexed under auto, radix, compare and DEFAULT: each index reads back the rows of
--     the compare-built index in the same order (0 rows differ) and finds as many rows

drop table if exists g;
drop table if exists t_auto;
drop table if exists t_radix;
drop table if exists t_compare;
drop table if exists t_default;

set system parameters 'index_sort_method=auto';
set system parameters 'index_sort_method=radix';
set system parameters 'index_sort_method=compare';
set system parameters 'index_sort_method=Radix';
set system parameters 'index_sort_method=quick';
set system parameters 'index_sort_method=';
set system parameters 'index_sort_method=DEFAULT';

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table t_auto (id int, k int);
create table t_radix (id int, k int);
create table t_compare (id int, k int);
create table t_default (id int, k int);
insert into t_auto select n, v from g order by n;
insert into t_radix select n, v from g order by n;
insert into t_compare select n, v from g order by n;
insert into t_default select n, v from g order by n;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=auto';
create index i_auto on t_auto (k);
set system parameters 'index_sort_method=radix';
create index i_radix on t_radix (k);
set system parameters 'index_sort_method=compare';
create index i_compare on t_compare (k);
set system parameters 'index_sort_method=DEFAULT';
create index i_default on t_default (k);
set system parameters 'index_build_buffer_size=DEFAULT';

-- rows read in index order that differ from the compare-built index: 0 each
select 'auto', count(*) from ((select rownum, k from t_auto where k >= -3003 using index i_auto)
  difference (select rownum, k from t_compare where k >= -3003 using index i_compare)) x;
select 'radix', count(*) from ((select rownum, k from t_radix where k >= -3003 using index i_radix)
  difference (select rownum, k from t_compare where k >= -3003 using index i_compare)) x;
select 'default', count(*) from ((select rownum, k from t_default where k >= -3003 using index i_default)
  difference (select rownum, k from t_compare where k >= -3003 using index i_compare)) x;

-- rows each index finds: all but the NULL ones
select count(*) from t_auto where k >= -3003 using index i_auto;
select count(*) from t_radix where k >= -3003 using index i_radix;
select count(*) from t_compare where k >= -3003 using index i_compare;
select count(*) from t_default where k >= -3003 using index i_default;

drop table g;
drop table t_auto;
drop table t_radix;
drop table t_compare;
drop table t_default;
