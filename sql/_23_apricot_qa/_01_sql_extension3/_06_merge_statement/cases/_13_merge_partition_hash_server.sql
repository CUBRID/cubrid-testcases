--merge into range partition table, on server side

autocommit off;



create table t1(id bigint, col1 varchar)
partition by hash(id) partitions 30;

insert into t1 values(1, 'aaa');
insert into t1 values(3, 'bbb');
insert into t1 values(15, 'ccc');
insert into t1 values(17, 'ddd');
insert into t1 values(29, 'eee');
insert into t1 values(21, 'fff');
insert into t1 values(33, 'ggg');
insert into t1 values(37, 'ddd');
insert into t1 values(35, 'hhh');
insert into t1 values(47, 'iii');
insert into t1 values(49, 'jjj');


create table t2(col1 varchar(1024), id bigint primary key)
partition by hash(id) partitions 50;
insert into t2 values('bbb', 2);
insert into t2 values('ddd', 38);
insert into t2 values('fff', 14);
insert into t2 values('hhh', 12);
insert into t2 values('jjj', 22);
insert into t2 values('kkk', 8);
insert into t2 values('ooo', 46);
insert into t2 values('sss', 28);
insert into t2 values('zzz', 99);


select * from t1 order by 1;
select * from t2 order by 1;


commit;


--TEST: update clause only, 3 rows merged
merge into t1
using t2
on t1.col1=t2.col1
when matched then
update set t1.id=t2.id
where t1.id < 30;

select if(count(*)=3, 'ok', 'nok') from t1 where id in {2, 14, 38};
select * from t1 order by 1;
rollback;


--TEST: insert clause only, 4 rows merged
merge into t1
using t2
on t1.col1=t2.col1
when not matched then
insert values(40, 'inserted');

select if(count(*)=15, 'ok', 'nok') from t1;
select if(count(*)=4, 'ok', 'nok') from t1 where col1='inserted';
rollback;


-- ############################ CUBRID BUG: CUBRIDSUS-9186 ###########################
--TEST: update + delete
merge into t1
using t2
on t1.col1=t2.col1
when matched then
update set t1.id=t2.id
where t1.id != 17
delete where t1.id =38;

select if(count(*)=10, 'ok', 'nok') from t1;
select * from t1 order by 1;
rollback;


-- ############################ CUBRID BUG: CUBRIDSUS-9186 ###########################
--TEST: update + delete + insert
merge into t1
using t2
on t1.col1=t2.col1
when matched then
update set t1.id=t2.id
delete where t1.id =38
when not matched then
insert(t1.col1, t1.id) values(t2.col1, t2.id)
where t2.col1!='zzz';

select if(count(*)=12, 'ok', 'nok') from t1;
select * from t1 order by 1;
rollback;


--TEST: [er], merge into a partition
merge into (select a.id, b.col1 from t1__p__p2 a, t1__p__p3 b) t1
using t2
on t1.col1=t2.col1
when matched then
update set t1.id=t2.id
delete where t1.id < 30;

select if(count(*)=11, 'ok', 'nok') from t1;
rollback;

--TEST: [er] merge into a partition
merge into t1__p__p4 tt
using t2
on tt.col1=t2.col1
when matched then
update set tt.id=t2.id
delete where tt.id=33
when not matched then
insert values(t2.id, t2.col1);

select if(count(*)=11, 'ok', 'nok') from t1;
rollback;


--TEST:  
merge into t1
using t2
on (t1.col1=t2.col1)
when matched then
update
set t1.id=t2.id+20
delete where t1.id < 10
when not matched then
insert
values(t2.id, t2.col1)
where t2.col1 != 'zzz';

select if(id=22, 'ok', 'nok') from t1 where col1='bbb';
select if(count(*)=14, 'ok', 'nok') from t1;
rollback;


-- ############################ CUBRID BUG: CUBRIDSUS-9186 ###########################
--TEST: 
merge into t1
using t2
on (t1.col1=t2.col1)
when matched then
update
set t1.id=t2.id
delete where t1.id < 30
when not matched then
insert
values(t2.id, t2.col1);

select if(count(*)=11, 'ok', 'nok') from t1;
select if(count(*)=4, 'ok', 'nok') from t1 where col1 in {'kkk', 'sss', 'ooo', 'zzz'};
select if(id=38, 'ok', 'nok') from t1 where col1='ddd';


drop table t1, t2;

commit;


autocommit on;




