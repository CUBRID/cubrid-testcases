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


commit;


--TEST: error, update the column that is referenced in the ON condition
merge into target t
using source s
on t.col2=s.col2
when matched then
update  
set t.col2=s.col2, t.col4=s.col4;

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
rollback;

--TEST: error, update the source table, without insert clause
merge into target t
using source s
on (t.col2=s.col2)
when matched then
update
set s.col3='1999-12-12 10:10:10', s.col4=t.col4;

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
rollback;

--TEST: error, update the source table, insert into target table
merge into target t
using source s
on (t.col2=s.col2)
when matched then
update
set s.col3='1999-12-12 10:10:10', s.col4=t.col4
when not matched then
insert(t.col1, t.col2)
values(s.col1, s.col2);

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
rollback;

--TEST: error, insert into the source table, without update clause
merge into target t
using source s
on (t.col1=s.col1)
when not matched then
insert(s.col1, s.col2)
values(s.col1, 'inserted');

select if(count(*)=6, 'ok', 'nok') from target;
select if(col2 in {'aaa', 'bbb', 'ccc', 'ddd', 'eee', 'fff'}, 'ok', 'nok') from target;
rollback;



drop table target, source;
commit;


autocommit on;



