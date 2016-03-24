--test with merge/replace/insert on duplicate key update syntax

autocommit off;


create table t1(id1 bigint , col1 time not null, primary key(id1, col1))
partition by range(col1)
(partition p1 values less than (time'12:12:13'),
partition p2 values less than (time'12:12:15'),
partition p3 values less than (time'12:12:18'));

insert into t1 values(1000000, '12:12:12'), (2000000, '12:12:13'), (3000000, '12:12:14'), (4000000, '12:12:15'), (5000000, '12:12:16'), (6000000, '12:12:15');


create table t2(col1 varchar(1024), id2 bigint, col2 time, primary key(id2, col2))
partition by range(col2)
(partition p1 values less than (time'12:12:12'),
partition p2 values less than (time'12:12:16'),
partition p3 values less than (time'14:14:15'));
insert into t2 values('cubrid', 1111111, '11:11:11'), ('abc', 2222222, '12:12:12'), ('a', 5000000, '12:12:15'), ('abcabc', 4444444, '10:10:10'), ('aa', 5555555, '12:12:13'), ('mysql', 2000000, '12:12:13');
insert into t2 values('cubridcubrid', 6666666, '13:13:13'), ('mysqlmysql', 4000000, '12:12:16'), ('aaaa', 565656565, '12:12:12'), ('abcabcabc', 6000000, '12:12:16'), ('hello', 7788777, '14:14:14'), ('hellohello', 90000909, '12:12:17');


create table trigger_actions1(id smallint auto_increment, info varchar);
create table trigger_actions2(id smallint auto_increment, info varchar);

create trigger trigg1 before update on t1 execute insert into trigger_actions1(info) values ('updated');
create trigger trigg2 after insert on t1 execute insert into trigger_actions1(info) values ('inserted');
create trigger trigg3 before update on t2 execute insert into trigger_actions2(info) values ('updated');
create trigger trigg4 after insert on t2 execute insert into trigger_actions2(info) values ('inserted');


commit;


--TEST: [er] replace into a partition 
replace into t1 partition (p1) values(1000000, '12:12:12');
--TEST: replace into, using a partition
replace into t1 set id1=6000000, col1=(select col2 from t2 partition (p2) where col1='a');
--TEST: check the result
select if(col1='12:12:15', 'ok', 'nok') from t1 partition (p3) where id1=6000000;
select if(count(*)=2, 'ok', 'nok') from trigger_actions1 where info='inserted';

rollback;


--TEST: [er] insert into a partition with 'on duplicate key update' syntax
insert into t2 partition (p3) values('updated', 2222222, '11:11:11') on duplicate key update col1='updated';
--TEST: insert on duplicate key update, using a partition
insert into t2 values('updated', 1111111, '11:11:11') on duplicate key update col1='updated', col2=(select col1 from t1 partition (p2) where id1=3000000);
--TEST: check the result
select if(col2='12:12:14' and col1='updated', 'ok', 'nok') from t2 partition (p2) aaa where id2=1111111;
select if(count(*)=1, 'ok', 'nok') from trigger_actions2 where info='updated';

rollback;



--TEST: [er] merge into a partition
merge into t2 partition (p3) t2
using t1 partition (p1) t1
on (t1.id1=t2.id2)
when matched then
update
set t2.col1='updated', t2.col2=t1.col1
when not matched then
insert
values('inserted', t1.id1, t1.col1);

--TEST: merge into range partition table, use a partition as the source
merge into t2
using t1 partition (p3) t1
on (t1.id1=t2.id2)
when matched then
update
set t2.col1='updated', t2.col2=t1.col1
when not matched then
insert
values('inserted', t1.id1, t1.col1);

select if(count(*)=3, 'ok', 'nok') from t2 where col1='updated';
select if(count(*)=0, 'ok', 'nok') from t2 where col1='inserted';
select if(count(*)=3, 'ok', 'nok') from trigger_actions2;


drop trigger trigg1, trigg2, trigg3, trigg4;
drop table t1, t2;
drop table trigger_actions1, trigger_actions2;

commit;


autocommit on;




