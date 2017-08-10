drop table if exists t;

create table t(i int) partition by hash(i) partitions 3;
insert into t select rownum from db_class limit 40;
select i from t where i = cast('1' as int);
drop table t;

create table t(d date) partition by list(d) (
	partition p0 values in ('2010-01-01', '2011-01-01'),
	partition p1 values in ('2012-01-01', '2013-01-01')
);
insert into t values('2010-01-01'), ('2011-01-01'), ('2012-01-01'), ('2013-01-01');
select * from t where d = concat(cast('2010' as varchar), '01', concat('0', 1));
drop table t;