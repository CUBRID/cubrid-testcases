--TEST: [Merge Statement] 'ERROR: Not allowed access to partition.' error occurs in a merge statement when there is an update trigger on the target table which is a range partition table.


create table t1(id bigint, col1 time)
partition by range(col1)
(partition p1 values less than (time'12:12:13'),
partition p2 values less than (time'12:12:15'));

insert into t1(id, col1) values(1000000, '12:12:12');


create table t2(id bigint, col1 time);
insert into t2 values(1000000, '12:12:13');


create table trigger_actions(id smallint auto_increment, info varchar);
create trigger trigg1 before update on t1 execute insert into trigger_actions(info) values ('updated');


merge into t1
using t2
on (t2.id=t1.id)
when matched then
update
set t1.col1=t2.col1;

select * from t1 order by 1;

insert into t1 values(2, '12:12:11');
insert into t2 values(2, '12:12:14');
insert into t2 values(100, '12:12:13');

merge into t1
using t2
on (t2.id=t1.id)
when matched then
update
set t1.col1=t2.col1
when not matched then
insert values(t2.id, t2.col1);

select * from t1 order by 1;

drop trigger trigg1;
drop table t1, t2, trigger_actions;
