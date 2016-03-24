--normal case: merge into target table using complex subquery-

autocommit off;


--create target table
create table target(
        col1 smallint primary key auto_increment,
        col2 string,
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


create table trigger_actions(id smallint auto_increment, info varchar);

create trigger trigg1 before update on target execute insert into trigger_actions(info) values ('updated');
create trigger trigg2 after insert on target execute insert into trigger_actions(info) values ('inserted');
create trigger trigg3 after delete on target execute insert into trigger_actions(info) values ('deleted');


commit;



--TEST: subquery of the target table itself
merge into target t
using (select * from target where col2 < 'ddd') s
on (floor(t.col1)=s.col1 and clob_to_char(s.col5)=clob_to_char(t.col5))
when matched then
update
set t.col2=repeat('updated', 1)
when not matched then
insert
values(s.col1, 'inserted', default, default, default);

select if (count(*)=3, 'ok', 'nok') from target where col2='updated';
select if (count(*)=3, 'ok', 'nok') from trigger_actions;

rollback;


--######################## CUBRID BUG: CUBRIDSUS-9155 ########################################
--TEST: subquery of the target table itself, with delete clause
merge into target t
using (select * from target where col2 < 'ddd') s
on (floor(t.col1)=s.col1 and clob_to_char(s.col5)=clob_to_char(t.col5))
when matched then
update
set t.col2=repeat('updated', 1)
delete where t.col1 > 100
when not matched then
insert
values(s.col1, 'inserted', default, default, default);

select if (count(*)=4, 'ok', 'nok') from target;
select if (count(*)=1, 'ok', 'nok') from target where col2='updated';
select if (count(*)=5, 'ok', 'nok') from trigger_actions;

rollback;


--TEST: select from 2 tables as the source table.
create table t1(a int, b char(10));
create table t2(a int, b varchar);

insert into t1 values(100, 'updated');
insert into t1 values(300, 'updated');
insert into t1 values(500, 'updated');
insert into t1 values(700, 'updated');


insert into t2 values(100, 'inserted');
insert into t2 values(300, 'inserted');
insert into t2 values(500, 'inserted');

commit;


--TEST: update+insert
merge into target t
using (select t1.a a, t1.b b, t2.b c from t1 left outer join t2 on t1.a=t2.a) s
on t.col1 = s.a
when matched then
update
set t.col2=s.b, t.col5=char_to_clob(upper('updated'))
when not matched then
insert
values(default, s.c, default, default, char_to_clob(upper('inserted')));

select if (count(*)=3, 'ok', 'nok') from target where col2='updated' and clob_to_char(col5)='UPDATED';
select if (count(*)=1, 'ok', 'nok') from target where col2 is null and col4 is null and clob_to_char(col5)='INSERTED';
select if (count(*)=4, 'ok', 'nok') from trigger_actions;

rollback;


--TEST: update + delete + insert
merge into target t
using (select t1.a a, t1.b b, t2.b c from t1 left outer join t2 on t1.a=t2.a) s
on t.col1 = s.a
when matched then
update
set t.col2=s.b, t.col5=char_to_clob(upper('updated'))
delete where clob_to_char(t.col5)='UPDATED' and s.a < 400
when not matched then
insert
values(default, s.c, default, default, char_to_clob(upper('inserted')));

select if (count(*)=5, 'ok', 'nok') from target;
select if (count(*)=1, 'ok', 'nok') from target where col2='updated' and clob_to_char(col5)='UPDATED';
select if (count(*)=1, 'ok', 'nok') from target where col2 is null and col4 is null and clob_to_char(col5)='INSERTED';
select if (count(*)=6, 'ok', 'nok') from trigger_actions;

rollback;

delete from target;

drop trigger trigg1, trigg2, trigg3;
drop table target, trigger_actions, t1, t2;
commit;


autocommit on;




