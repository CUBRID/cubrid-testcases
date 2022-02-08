--TEST: [FilteredIndex ] Filter Index can be created when using condition of 'where [expression] is null'.

drop table if exists t;

create table t(a int, b int);
insert into t values(1, null), (null, 2), (4, null), (null, 3);
--select result is null
select * from t where (not a<>0) is null order by b;

--error should occur
create index i1 on t(a) where (not a<>0) is null;
create index i2 on t(a) where null is null;
create index i3 on t(a) where b is null;
create index i4 on t(a) where a/0 is null;
create index i5 on t(a) where a+null is null;


drop table t;




