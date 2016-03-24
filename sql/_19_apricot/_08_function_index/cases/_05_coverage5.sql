create table t1 (i int, d double);

create index idx on t1 (sqrt(d));

create index idx2 on t1 (i) where i > 15;

insert into t1 values (4,25), (16,256), (20,400);
update statistics on all classes;
SHOW INDEXES FROM t1;

alter table t1 change column d newd double;
update statistics on all classes;
SHOW INDEXES FROM t1;

alter table t1 change column i newi int;
update statistics on all classes;
SHOW INDEXES FROM t1;

select /*+ recompile */ * from t1 where sqrt(newd) > 5;

select /*+ recompile */ * from t1 where newi < 20 using index idx2(+);

insert into t1 values (30, 900);

select /*+ recompile */ * from t1 where sqrt(newd) > 5;

select /*+ recompile */ * from t1 where newi < 20 using index idx2(+);

drop table t1;
