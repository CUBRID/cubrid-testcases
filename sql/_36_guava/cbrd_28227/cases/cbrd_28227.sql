-- CBRD-28227: range merging compared two string constants as CHARs (trailing spaces ignored, CBRD-24149)
-- while the predicate compares a VARCHAR column with each constant as VARCHAR.
-- The two constants were taken as equal and the rows of one of them were lost, depending on the OR order.

drop table if exists t28227;
create table t28227 (id int, v varchar(10), w varchar(10) collate utf8_en_ci, c char(10), x int);
insert into t28227 values (1, 'a', 'a', 'a', 1), (2, 'a ', 'a ', 'a ', 1), (3, 'a  ', 'a  ', 'a  ', 1), (4, 'A', 'A', 'A', 1), (5, 'b', 'b', 'b', 1), (6, 'aB', 'aB', 'aB', 1), (7, 'a  ', 'a  ', 'a  ', 2);

-- Case 1: no index. compile-time range merge (qo_merge_range_helper)
select id, '[' || v || ']' from t28227 where v = 'a' or v = 'a  ' order by id;
select id, '[' || v || ']' from t28227 where v = 'a  ' or v = 'a' order by id;
select id, '[' || w || ']' from t28227 where w = 'a  ' or w = 'A' order by id;
select id, '[' || w || ']' from t28227 where w = 'A' or w = 'a  ' order by id;
select id, '[' || v || ']' from t28227 where v between 'a' and 'a ' or v = 'a  ' order by id;
select id, '[' || w || ']' from t28227 where w >= 'b' or w in ('a  ', 'A', (select 'aB')) order by id;
select id, '[' || v || ']' from t28227 where (v = 'a' or v = 'a  ') and x = 1 order by id;
-- a CHAR column ignores trailing spaces: every row of 'a', 'a ' and 'a  '
select id, '[' || c || ']' from t28227 where c = 'a' or c = 'a  ' order by id;

-- Case 2: single-column index. the same queries, and runtime key range merge (merge_key_ranges)
create index i28227_v on t28227 (v);
create index i28227_w on t28227 (w);
select /*+ recompile */ id, '[' || v || ']' from t28227 where v = 'a' or v = 'a  ' order by id;
select /*+ recompile */ id, '[' || w || ']' from t28227 where w = 'a  ' or w = 'A' order by id;
select /*+ recompile */ id, '[' || v || ']' from t28227 where v between 'a' and 'a ' or v = 'a  ' order by id;
select /*+ recompile */ id, '[' || v || ']' from t28227 where v = (select 'a') or v = (select 'a  ') order by id;
select /*+ recompile */ id, '[' || v || ']' from t28227 where v = (select 'a  ') or v = (select 'a') order by id;
select /*+ recompile */ id, '[' || w || ']' from t28227 where w = (select 'a  ') or w = (select 'A') order by id;
drop index i28227_v on t28227;
drop index i28227_w on t28227;

-- Case 3: multi-column index. two search keys of one CHAR domain on a VARCHAR column (pr_midxkey_compare_resolved)
create index i28227_vx on t28227 (v, x);
select /*+ recompile */ id, '[' || v || ']' from t28227 where v = 'a' or v = 'a  ' order by id;
select /*+ recompile */ id, '[' || v || ']' from t28227 where v = 'a  ' or v = 'a' order by id;
select /*+ recompile */ id, '[' || v || ']' from t28227 where v = (select 'a') or v = (select 'a  ') order by id;
select /*+ recompile */ id, '[' || v || ']' from t28227 where (v = 'a' or v = 'a  ') and x = 1 order by id;
select /*+ recompile */ id, '[' || v || ']' from t28227 where v between 'a' and 'a ' or v = 'a  ' order by id;

drop table t28227;
