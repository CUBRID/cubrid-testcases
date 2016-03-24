--Unique violation error occurs when executing ODKU statement on a partition table with a multi-column pk.

drop table if exists t1;

create table t1(a int, b char(10), c smallint, primary key(a, b))
partition by hash(a) partitions 5;
insert into t1(a, b, c) values(1, 'd', 100);

alter table t1 add column d varchar(10);
insert into t1(a, b, c) values(1, 'd', 999) on duplicate key update d='add';
select * from t1 order by 1; 

alter table t1 drop primary key;
alter table t1 add constraint pk_a_b_d primary key(a, b, d);

insert into t1(a, b, d) values(1, 'd', 'add') on duplicate key update d='updated';
select * from t1 order by 1;

insert into t1(a, b, d) values(1, 'd', 'updated') on duplicate key update c=111;
select * from t1 order by 1;
replace into t1 values(1, 'd', 222, 'updated');
select * from t1 order by 1;


drop table t1;




