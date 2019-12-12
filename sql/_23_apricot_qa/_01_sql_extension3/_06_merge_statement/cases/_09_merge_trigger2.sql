--test with trigger: update trigger
--trigger action: insert


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
insert into source values(6.6, 'aaa', '2011-12-12 14:20:35', {1, 3, 4});
insert into source values(7.8, 'bbb', '2011-12-12 14:20:36', {1, 4, 4});
insert into source values(6.5, 'bbb', '2011-12-12 14:20:37', {1, 2, 4});
insert into source values(8.8, 'ccc', '2011-12-12 14:20:38', {1, 2, 3});
insert into source values(5.6, 'ccc', '2011-12-12 14:20:39', {1, 2, 4});


--create trigger action table
create table trigger_actions(id int auto_increment, a smallint, b string, c datetime default SYS_DATETIME);

--create trigger
create trigger bef_upd before update on target execute
	insert into trigger_actions(a, b) values(11, 'before update');
create trigger aft_upd after update on target execute
	insert into trigger_actions(a, b) values(22, 'after update');

commit;


--TEST: with insert clause only
merge into target t
using source s
on t.col2=s.col2 and t.col3=s.col3
when matched then
update
set t.col1 = s.col1, t.col4 = s.col4;
--TEST: check merge result
select * from target order by 1,2;
--TEST: check trigger action table
select if (count(*) = 12, 'ok', 'nok') from trigger_actions;

rollback;



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
select * from target order by 1,2;
--TEST: check trigger action table
select if (count(*) = 12, 'ok', 'nok') from trigger_actions;

rollback;



drop trigger bef_upd, aft_upd;
drop table target, source, trigger_actions;
commit;


autocommit on;
