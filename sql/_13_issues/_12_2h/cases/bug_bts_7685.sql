--TEST: [Function Based Index] expect Function Based Index can be dropped by index name


create table t1 (a int, b varchar(10));

create index i1 on t1 (upper(b));
drop index i1 on t1;

create index i1 on t1 (upper(b));
drop index i1 ON t1(upper(b));

drop table t1;


create table t1 (a int, b varchar(10));
create index i1 on t1 (upper(b));
create index i2 on t1 (a);

insert into t1 select rownum, rownum||'' from db_class a, db_class b, db_class c limit 10000;

--test: Function index name can't be used in USING INDEX.
select /*+ recompile */ * from t1 where a=100 and upper(b)='100' using index i1;


drop index i1 on t1;
drop index i2 on t1;


drop table t1;
