--test triggers with DATETIMETZ column

autocommit off;

drop table if exists tz_test;
create table tz_test(id int, dttz datetime with time zone primary key, str varchar(20)) partition by hash(dttz) partitions 5;

--test: create trigger action table
create table trigger_actions(id int auto_increment, dttz datetime with time zone unique, str varchar(20)) partition by hash(dttz) partitions 5;
--test: create triggers
create trigger bef_del1 before delete on tz_test 
	execute	insert into trigger_actions(dttz, str) values((select max(dttz) from trigger_actions)+1*1000, 'before delete');
create trigger bef_del2 before delete on tz_test 
	execute	print 'Before delete trigger is triggered!';
create trigger aft_del1 after delete on tz_test 
        execute insert into trigger_actions(dttz, str) values((select max(dttz) from trigger_actions)+1*1000, 'after delete');
create trigger aft_del2 after delete on tz_test 
        execute print 'After delete trigger is triggered!';
create trigger bef_ins1 before insert on tz_test
	execute insert into trigger_actions(dttz, str) values((select max(dttz) from trigger_actions)+1*1000, 'before insert');
create trigger bef_ins2 before insert on tz_test
	execute print 'Before insert trigger is triggered!';
create trigger aft_ins1 before insert on tz_test
        execute insert into trigger_actions(dttz, str) values((select max(dttz) from trigger_actions)+1*1000, 'after insert');
create trigger aft_ins2 before insert on tz_test
	execute print 'After insert trigger is triggered!';
create trigger bef_upd1 before update on tz_test
	execute insert into trigger_actions(dttz, str) values((select max(dttz) from trigger_actions)+1*1000, 'before update');
create trigger bef_upd2 before update on tz_test
	execute print 'Before update trigger is triggered!';
create trigger aft_upd1 before update on tz_test
	execute insert into trigger_actions(dttz, str) values((select max(dttz) from trigger_actions)+1*1000, 'after update');
create trigger aft_upd2 before update on tz_test
	execute print 'After update trigger is triggered!';
create trigger aft_upd3 before update on tz_test
	if new.dttz < obj.dttz execute reject;

insert into trigger_actions(dttz, str) values(datetimetz'2000-12-12 21:00:00.999 +5:00', 'initialization');

commit;

set timezone '+9:00';
--test: insert
insert into tz_test values(1, datetimetz'2025-12-31 14:00:00.999', 'inserted');
select * from tz_test order by 1;
select if(count(*)=2, 'ok', 'nok') from trigger_actions where str in ('before insert', 'after insert');

--test: [er] update, should be rejected
update tz_test set dttz=dttz-1;
select if(count(*)=0, 'ok', 'nok') from trigger_actions where str in ('before update', 'after update');

--test: replace
replace into tz_test values(2, datetimetz'2025-12-31 14:00:00.999', 'replaced');
select * from tz_test order by 1;
select if(count(*)=2, 'ok', 'nok') from trigger_actions where str in ('before delete', 'after delete');
select if(count(*)=4, 'ok', 'nok') from trigger_actions where str in ('before insert', 'after insert'); 

--test: [er] odku, should be rejected
insert into tz_test values(3, datetimetz'2025-12-31 14:00:00.999', 'odku') on duplicate key update dttz=dttz-1, str='odku';
select * from tz_test order by 1;
select if(count(*)=7, 'ok', 'nok') from trigger_actions;
select if(count(*)=0, 'ok', 'nok') from trigger_actions where str in ('before update', 'after update');

--test: odku
insert into tz_test values(3, datetimetz'2025-12-31 14:00:00.999', 'odku') on duplicate key update dttz=dttz+1*1000, str='odku';
select if(count(*)=2, 'ok', 'nok') from trigger_actions where str in ('before update', 'after update');

--test: merge
create table source(id int, dttz datetime with time zone, str varchar(100));
insert into source values(11, datetimetz'2025-12-31 14:00:01.999', 'from source updated');
insert into source values(22, datetimetz'2025-12-31 14:01:01.999', 'from source inserted');

merge into tz_test t using source s
on (t.dttz=s.dttz)
when matched then update set t.str=s.str, t.id=s.id
delete where s.id=11
when not matched then
insert values (s.id, s.dttz, s.str);

select * from tz_test order by 1;
select if(count(*)=4, 'ok', 'nok') from trigger_actions where str in ('before update', 'after update');
select if(count(*)=4, 'ok', 'nok') from trigger_actions where str in ('before delete', 'after delete');
select if(count(*)=6, 'ok', 'nok') from trigger_actions where str in ('before insert', 'after insert');

rollback;

select if(count(*)=0, 'ok', 'nok') from tz_test;
select if(count(*)=1, 'ok', 'nok') from trigger_actions;

drop trigger bef_del1, bef_del2, aft_del1, aft_del2, bef_ins1, bef_ins2, aft_ins1, aft_ins2, bef_upd1, bef_upd2, aft_upd1, aft_upd2, aft_upd3;
drop table trigger_actions, tz_test;

commit;

set timezone 'Asia/Seoul';


autocommit on;

