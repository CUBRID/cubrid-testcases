create table t(i int) partition by hash(i) partitions 5;

insert into t select rownum from _db_class limit 40;

insert into t partition (p0) values(1);

insert into t partition (p0) select * from t partition (p1);

insert into t select * from t partition (p1);

drop table t;
