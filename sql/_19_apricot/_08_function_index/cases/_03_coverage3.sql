create table t1 (i int, d double);

create index idx on t1 (sqrt(d));

create index idx2 on t1 (i) where i > 15;

insert into t1 values (4,25), (16,256), (20,400);
update statistics on all classes;
SHOW INDEXES FROM t1;

alter table t1 drop index idx;
update statistics on all classes;
SHOW INDEXES FROM t1;

alter table t1 drop index idx2;
update statistics on all classes;
SHOW INDEXES FROM t1;

drop table t1;
