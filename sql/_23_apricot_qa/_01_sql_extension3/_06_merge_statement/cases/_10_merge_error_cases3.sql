--error case testing

autocommit off;

--create target table
create table target(
        col1 smallint primary key,
        col2 string not null,
        col3 timestamp default SYS_TIMESTAMP,
        col4 bit(20) unique,
	col5 clob
);

insert into target values(100, 'aaa', '2011-12-12 14:20:34', B'0001', 'AAA');
insert into target values(200, 'bbb', '2011-12-12 14:20:34', B'0010', 'BBB');
insert into target values(300, 'ccc', '2011-12-12 14:20:35', B'0100', 'CCC');
insert into target values(400, 'ddd', '2011-12-12 14:20:36', B'1000', 'DDD');
insert into target values(500, 'eee', '2011-12-12 14:20:36', B'0011', 'EEE');
insert into target values(600, 'fff', '2011-12-12 14:20:37', B'0101', 'FFF');


--create source table
create table source(
        col1 double,
        col2 varchar not null,
        col3 datetime default SYS_DATETIME,
        col4 bit varying(20),
	col5 char(10)
);


insert into source values(100, 'ggg', '2011-11-11 14:20:38.999', B'0001', 'AAA');
insert into source values(200, 'hhh', '2011-10-10 14:20:34.999', B'1010', 'BBB');
insert into source values(300, 'iii', '2011-12-12 14:20:34', B'0100', 'CCC');
insert into source values(700, 'ddd', '2011-12-12 14:20:34', B'1000', 'DDD');
insert into source values(800, 'ddd', '2011-12-12 14:20:35', B'1011', 'EEE');
insert into source values(900, 'fff', '2011-12-12 14:20:36', B'0101', 'FFF');


--TEST: create triggers
create table trigger_actions1(id smallint auto_increment, info varchar);
create table trigger_actions2(id smallint auto_increment, info varchar);

create trigger trigg1 before statement update on target execute insert into trigger_actions1(info) values ('updated');
create trigger trigg2 after statement insert on target execute insert into trigger_actions1(info) values ('inserted');
create trigger trigg3 before statement update on source execute insert into trigger_actions2(info) values ('updated');
create trigger trigg4 after statement insert on source execute insert into trigger_actions2(info) values ('inserted');



commit;


--TEST: error, unmatched data types in on condition
merge into target t
using source s
on t.col2=s.col1
when matched then
update  
set t.col4=s.col4;

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
select if (count(*)=0, 'ok', 'nok') from trigger_actions1;

rollback;

--TEST: error, unmatched data types in on condition
merge into target t
using source s
on (t.col3=s.col4)
when matched then
update
set t.col3='1999-12-12 10:10:10', t.col4=t.col4;

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
select if (count(*)=0, 'ok', 'nok') from trigger_actions1;

rollback;

--TEST: error, unmatched data types in on condition
merge into source s
using target t
on t.col4=s.col5
when matched then
update
set s.col3='1999-12-12 10:10:10', s.col4=t.col4
when not matched then
insert(s.col1, s.col2)
values(t.col1, t.col2);

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
select if (count(*)=0, 'ok', 'nok') from trigger_actions2;
rollback;

--TEST: error, update with invalid data type
merge into target t
using source s
on (t.col1=s.col1)
when not matched then
insert(t.col1, t.col2, t.col3)
values(s.col1, 'inserted', 'abc');

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
select if (count(*)=0, 'ok', 'nok') from trigger_actions1;
rollback;



drop trigger trigg1, trigg2, trigg3, trigg4;
drop table target, source;
drop table trigger_actions1, trigger_actions2;
commit;


autocommit on;




