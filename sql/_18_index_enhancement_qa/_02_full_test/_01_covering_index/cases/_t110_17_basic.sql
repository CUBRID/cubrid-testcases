--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(user_id int primary key, age int, user_name varchar(1073741823));
create index idx_t1_all on t1(user_id, age,user_name);
create index idx_t1_age_name on t1(age, user_name);
create index idx_t1_age on t1(age);

insert into t1 values (2, 19, 'Rose');
insert into t1 values (1, 18, 'John_1');
insert into t1 values (3, 17, 'John_3');
insert into t1 values (4, 21, 'John_4');

--TEST: should use idx_t1_?
select /*+ RECOMPILE */ count(age||user_name) from t1 where rownum=1;

--TEST: should use idx_t1_all
select /*+ RECOMPILE */ count(user_id||age||user_name) from t1 where rownum=1;

--TEST: should use idx_t1_age_name for 'a' table, idx_t1_age for 'b' table, idx_t1_all for 'c' table;
select /*+ RECOMPILE */ count(a.age||a.user_name),(select count(b.age) from t1 b where rownum=1) as col1 
  from t1 a where exists (select * from t1 c);

--TEST: should use idx_t1_all
select /*+ RECOMPILE */ count(a.user_id) from t1 a where a.age>0 and a.user_name is not null;

--TEST: should use idx_t1_all for 'a' table, idx_t1_age_name for 'b' table;
select /*+ RECOMPILE ORDERED */ count(a.user_id) from t1 a, t1 b where a.age>0 and a.user_name is not null and b.age > 0;


drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
