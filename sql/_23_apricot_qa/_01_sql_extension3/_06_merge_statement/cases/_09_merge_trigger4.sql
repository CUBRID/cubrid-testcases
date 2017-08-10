--test with trigger: insert and update triggers
--trigger action: merge, mix


autocommit off;


--create target table
create table target(
	col1 float,
	col2 char(30) not null,
	col3 timestamp default SYS_TIMESTAMP,
	col4 sequence(int),
	primary key(col2, col3)
);

insert into target values(5.5, 'aaa', '2011-12-12 14:20:34', {1, 2, 4});
insert into target values(6.6, 'aaa', '2011-12-12 14:20:35', {1, 2, 4});
insert into target values(7.7, 'bbb', '2011-12-12 14:20:36', {1, 2, 4});
insert into target values(5.5, 'bbb', '2011-12-12 14:20:37', {1, 2, 4});
insert into target values(8.8, 'ccc', '2011-12-12 14:20:38', {1, 2, 4});
insert into target values(5.6, 'ccc', '2011-12-12 14:20:39', {1, 2, 4});


--create source table
create table source(
	col1 float,
	col2 char(30),
	col3 timestamp default SYS_TIMESTAMP,
	col4 sequence(int),
	primary key(col2, col3)
);

--with same pk values
insert into source values(6.5, 'aaa', '2011-12-12 14:20:34', {1, 2, 4});
insert into source values(6.6, 'ddd', '2011-12-12 14:20:35', {1, 3, 4});
insert into source values(7.8, 'bbb', '2011-12-12 14:20:36', {1, 4, 4});
insert into source values(6.5, 'eee', '2011-12-12 14:20:37', {1, 2, 4});
insert into source values(8.8, 'ccc', '2011-12-12 14:20:38', {1, 2, 3});
insert into source values(5.6, 'fff', '2011-12-12 14:20:39', {1, 2, 4});


commit;



--create trigger, trigger action: insert
create trigger aft_upd after update on target execute
        insert into source values(11.11, 'aft_upd', adddate(obj.col3, 1), {1, 2, 3});
create trigger aft_ins before insert on target execute
        insert into source values(22.22, 'bef_ins', adddate(new.col3, 1), {1, 2, 3});


--TEST: with insert and update clause
merge into target t
using source s
on t.col2=s.col2 and t.col3=s.col3
when matched then
update
set t.col1=s.col1, t.col4=s.col4
when not matched then
insert
values(s.col1, s.col2, s.col3, s.col4);
--TEST: check merge result
select * from target order by 1;
--TEST: check trigger action table
select if (count(*) = 3, 'ok', 'nok') from source where col2='aft_upd';
select if (count(*) = 3, 'ok', 'nok') from source where col2='bef_ins';

rollback;





--create trigger, trigger action: insert into the source table.
create trigger bef_upd before update on target execute
        insert into source values(11.11, 'aft_upd', adddate(obj.col3, 1), {1, 2, 3});
create trigger aft_ins after insert on source execute
        update target set col3=adddate(col3, 2);


--TEST: error, unique constraint violation
merge into target t
using source s
on t.col2=s.col2 and t.col3=s.col3
when matched then
update
set t.col1=s.col1, t.col4=s.col4
when not matched then
insert
values(s.col1, s.col2, s.col3, s.col4);
--TEST: check merge result
select if(count(*)=6, 'ok', 'nok') from target;
select if(count(*)=6, 'ok', 'nok') from source;

rollback;


drop table target, source;
commit;


autocommit on;
