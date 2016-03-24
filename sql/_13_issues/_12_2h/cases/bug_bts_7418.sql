--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
drop table if exists t1;
create table t1 (a int, b string, c datetime);
create index t1_a on t1 (a);
create index t1_b on t1 (b);
create index t1_c on t1 (c);

drop table if exists t_i;
create table t_i (s string);
create index t_i_s on t_i (s);

select /*+ recompile */ a from t1 where a > 0 order by cast(a as short);
select /*+ recompile */ a from t1 where a > 0 order by cast(a as float);
select /*+ recompile */ a from t1 where a > 0 order by cast(a as double);
select /*+ recompile */ a from t1 where a > 0 order by cast(a as numeric);
select /*+ recompile */ a from t1 where a > 0 order by cast(a as string);

select /*+ recompile */ cast(a as short) from t1 where a > 0 order by cast(a as short);
select /*+ recompile */ cast(a as float) from t1 where a > 0 order by cast(a as float);
select /*+ recompile */ cast(a as double) from t1 where a > 0 order by cast(a as double);
select /*+ recompile */ cast(a as numeric) from t1 where a > 0 order by cast(a as numeric);
select /*+ recompile */ cast(a as string) from t1 where a > 0 order by cast(a as string);

select /*+ recompile */ b from t1 where b > 'a' order by cast(b as char);
select /*+ recompile */ b from t1 where b > 'a' order by cast(b as numeric);

select /*+ recompile */ cast(b as char) from t1 where b > 'a' order by cast(b as char);
select /*+ recompile */ cast(b as numeric) from t1 where b > 'a' order by cast(b as numeric);

select /*+ recompile */ c from t1 where c > '0000-00-00 00:00:00' order by cast(c as date);
select /*+ recompile */ c from t1 where c > '0000-00-00 00:00:00' order by cast(c as timestamp);
select /*+ recompile */ c from t1 where c > '0000-00-00 00:00:00' order by cast(c as time);

select /*+ recompile */ cast(c as date) from t1 where c > '0000-00-00 00:00:00' order by cast(c as date);
select /*+ recompile */ cast(c as timestamp) from t1 where c > '0000-00-00 00:00:00' order by cast(c as timestamp);
select /*+ recompile */ cast(c as time) from t1 where c > '0000-00-00 00:00:00' order by cast(c as time);

select /*+ recompile */ cast (s as char(10)) from t_i where cast (s as char(10)) > 'a' order by 1;
select /*+ recompile */ cast (s as string collate 'utf8_en_ci') from t_i where cast (s as  string collate 'utf8_en_ci') > 'a' order by 1;

drop table t1;
drop table t_i;
commit;
set system parameters 'dont_reuse_heap_file=no';
--+ holdcas off;
