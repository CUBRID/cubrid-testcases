create table t1 (id int primary key not null, a char(20), b timestamp);
insert into t1 select rownum, 'AZ-'||rownum, now() from db_class a, db_class b, db_class c limit 10000;
create index i_t1_a_b on t1(a,b);
create index i_t1_a on t1(a);
create index i_t1_id_a_b on t1(id,a,b);

--test
select /*+ recompile */ a from t1 where a>'A' using index i_t1_a limit 0, 10;
--test
select /*+ recompile */ a from t1 use index (i_t1_a) where a>'A' limit 0,10;

--test
select /*+ recompile */ a from t1 use index (i_t1_a) where a>'A' limit 1,10;
--test
select /*+ recompile */ a from t1 use index (i_t1_a) where a>'A'  limit 5;
--test
select /*+ recompile */ a from t1 use index (i_t1_a) where a>'A' limit 0;
--test: should fail
select /*+ recompile */ a from t1 use index (i_t1_a) keylimit 5 where a>'A';
--test
select /*+ recompile */ a from t1 use index (i_t1_a) where a>'A' limit 0;
--test

select /*+ recompile */ id%10,count(*) from t1 where id>0 group by id%10 using index pk_t1_id;
--test
select /*+ recompile */ id%10,count(*) from t1 use index (pk_t1_id) where id>0 group by id%10;
--test
select /*+ recompile */ id%10,count(*) from t1 use index (none) where id>0 group by id%10;


drop table t1;

