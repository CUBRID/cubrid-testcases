create table t1 (id int primary key not null, a char(20), b timestamp);
insert into t1 select rownum, 'AZ-'||rownum, now() from db_class a, db_class b, db_class c limit 10000;
create index i_t1_a_b on t1(a,b);
create index i_t1_a on t1(a);
create index i_t1_id_a_b on t1(id,a,b);

--test: should fail
select /*+ recompile */ sum(id) from t1  where a>'A' and id>0 using index none(-);

--test: should fail
select /*+ recompile */ sum(id) from t1  where a>'A' and id>0 using index t1.none(-);

--test: should fail
select /*+ recompile */ sum(id) from t1  where a>'A' and id>0 using index pk_t1_id(--);
--test: should fail
select /*+ recompile */ sum(id) from t1  where a>'A' and id>0 using index pk_t1_id(+-);
--test: should fail
select /*+ recompile */ sum(id) from t1  where a>'A' and id>0 using index pk_t1_id(-+);

--test
select /*+ recompile */ sum(id) from t1  where a>'--';

--test
select /*+ recompile */ sum(id) from t1  where a>'A' and id>0 using index pk_t1_id(-),pk_t1_id(+);

--test
select /*+ recompile */ sum(length(a)) from t1  where a>'A' using index i_t1_a(+),i_t1_a(+);

--test
select /*+ recompile */ sum(length(a)) from t1  where a>'A' using index i_t1_a(-),i_t1_a(+);

--test
select /*+ recompile */ sum(length(a)) from t1  where a>'A' using index i_t1_a(-),i_t1_a(-);

--test
select /*+ recompile */ sum(length(a)) from t1  where a>'A' using index i_t1_a(-)(+);

--test
select /*+ recompile */ sum(length(a)) from t1  where a>'A' using index i_t1_a(-);

drop table t1;


