create table t(i int) partition by hash(i) partitions 5;

insert into t select rownum from _db_class limit 40;

delete from t partition (p0);

insert into t partition (p0) select * from t partition (p2) where i = 10;

delete t from t, t partition (p0) u where u.i = t.i;

delete t partition (p0) from t partition (p0);

drop table t;
