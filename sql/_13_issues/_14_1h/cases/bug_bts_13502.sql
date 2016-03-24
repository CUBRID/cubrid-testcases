--Unique violation error occurs when executing ODKU statement on a partition table with a multi-column pk.

drop table if exists t1;

create table t1(a int, b char(10), c smallint, primary key(a, b))
partition by hash(a) partitions 5;
insert into t1(a, b, c) values(1, 'd', 100);

insert into t1(a, b, c) values(1, 'd', 999) on duplicate key update c=1;
select * from t1 order by 1;

replace into t1(a, b, c) values(1, 'd', 999);
select * from t1 order by 1;

drop table t1;




