create table t1 (id int primary key not null, a char(20), b timestamp);
create serial s start with 1 INCREMENT by 1;
insert into t1 select s.next_value, 'AZ-'||s.next_value, now() from db_class a, db_class b, db_class c limit 10000;
drop serial s;
create index i_t1_a_b on t1(a,b);
create index i_t1_a on t1(a);
create index i_t1_id_a_b on t1(id,a,b);

--test: should fail
select /*+ recompile */ a from t1 use index i_t1_a where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(i_t1_a, i_t1_a_b) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(i_t1_a_b) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(pk_t1_id) where a>'A' order by 1 limit 1,10;

--test
select /*+ recompile */ a from t1 use index(pk_t1_id, i_t1_a_b, i_t1_a) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(pk_t1_id, i_t1_a, i_t1_a_b) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(none) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(hijack) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(t1.none) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(t1.i_t1_a) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(i_t1_a, `sss`) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 use index(i_t1_a) where a>'A' limit 1,10;

--test: should fail
select /*+ recompile */ a from t1 force index i_t1_a where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(i_t1_a, i_t1_a_b) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(i_t1_a_b) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(pk_t1_id) where a>'A' order by 1 limit 1,10;

--test
select /*+ recompile */ a from t1 force index(pk_t1_id, i_t1_a_b, i_t1_a) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(pk_t1_id, i_t1_a, i_t1_a_b) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(none) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(hijack) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(t1.none) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(t1.i_t1_a) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(i_t1_a, `sss`) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 force index(i_t1_a) where a>'A' limit 1,10;

--test: should fail
select /*+ recompile */ a from t1 ignore index i_t1_a where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(i_t1_a, i_t1_a_b) where a>'A' order by 1 limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(i_t1_a_b) where a>'A' order by 1 limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(pk_t1_id) where a>'A' order by 1 limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(pk_t1_id, i_t1_a_b, i_t1_a) where a>'A' order by 1 limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(pk_t1_id, i_t1_a, i_t1_a_b) where a>'A' order by 1 limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(none) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(hijack) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(t1.none) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(t1.i_t1_a) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(i_t1_a, `sss`) where a>'A' limit 1,10;

--test
select /*+ recompile */ a from t1 ignore index(i_t1_a) where a>'A' order by 1 limit 1,10;

--test: should fail
select /*+ recompile */ a from t1 use index (i_t1_a) force index (i_t1_a) where a>'A' limit 1,10;

--test: should fail
select /*+ recompile */ a from t1 ignore index (i_t1_a) force index (i_t1_a) where a>'A' limit 1,10;

drop table t1;

