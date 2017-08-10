create table t(i int) partition by hash(i) partitions 5;

insert into t select rownum from _db_class limit 40;

update t partition (p0) set i = 6 where i = 5;

update t t, t partition (p0) u set t.i = 1, u.i = 1 where t.i = u.i;

update t t , t partition (p0) u set t.i = 1 where t.i = u.i;

drop table t;
