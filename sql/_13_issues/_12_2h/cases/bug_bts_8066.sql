--TEST: [Merge Statement] Core dumped when using joined tables as the target table.


create table t1(id bigint, col1 varchar);
insert into t1 values(1, 'aaa');
insert into t1 values(3, 'bbb');


create table t2(id bigint, col1 varchar(1024));
insert into t2 values(1, 'bbb');
insert into t2 values(38, 'ddd');

--Segmentation fault, error expected
merge into (select * from t1, t2) t1
using t2
on t1.id=t2.id
when matched then
update set t1.col1=t2.col1;


merge into (select t1.id as id, t2.col1 as col1 from t1, t2) t1
using t2
on t1.id=t2.id
when matched then
update set t1.col1=t2.col1;


drop table t1, t2;
