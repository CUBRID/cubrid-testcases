drop table if exists t;

create table t(i int, j int) partition by range(i) (
partition p0 values less than (1),
partition p1 values less than (10),
partition p2 values less than (100),
partition p3 values less than MAXVALUE
);

Create unique index idx on t(i) with online;
select /*+ RECOMPILE */ * from t__p__p0 where i>0;
drop t;



drop table if exists t1;

create table t1(i int, j int) partition by range(i) (
partition p0 values less than (1),
partition p1 values less than (10),
partition p2 values less than (100),
partition p3 values less than MAXVALUE
);

insert into t1 values(-1,-1);
insert into t1 values(5,5);
insert into t1 values(99,99);
insert into t1 values(100,100);

create unique index idx on t1(i,j) with online;

select /*+ RECOMPILE */ * from t1__p__p3 where i>0;

drop t1;

