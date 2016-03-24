--merge into list partition table

autocommit off;


create table t1(id1 numeric(10, 5), col1 timestamp not null default CURRENT_TIMESTAMP, col2 char(50))
partition by list(col2) (
partition p1 values in ('cubrid', 'mysql', 'abc'),
partition p2 values in ('cubridcubrid', 'mysqlmysql', 'abcabc'),
partition p3 values in ('updated', 'inserted')
);
insert into t1 values(11111.11111, '2011-09-01 12:12:12', 'cubrid'), (22222.22222, '2011-09-01 12:12:13', 'mysql'), (33333.33333, '2011-09-01 12:12:14', 'abc'), (44444.44444, '2011-09-01 12:12:15', 'cubridcubrid'), (55555.55555, '2011-09-01 12:12:16', 'mysqlmysql'), (66666.66666, '2011-09-01 12:12:17', 'abcabc');


create table t2(col1 varchar(1024), id2 numeric(10, 5), index i(id2 desc, col1))
partition by list(col1) (
partition p1 values in ('cubrid', 'mysql', 'abc'),
partition p2 values in ('cubridcubrid', 'mysqlmysql', 'abcabc', 'abcabcabc'),
partition p3 values in ('a', 'aa', 'aaa', 'aaaa'),
partition p4 values in ('hello', 'hellohello'),
partition p5 values in ('updated', 'inserted')
);
insert into t2 values('cubrid', 1234.12345), ('abcabc', 3456.34555), ('a', 55555.55555), ('abcabc', 444.12345), ('aa', 5555.1234), ('mysql', 22222.22222);
insert into t2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444), ('aaaa', 5656.56565), ('abcabcabc', 66666.66666), ('hello', 77.88777), ('hellohello', 90000.909);


select * from t1 order by id1;
select * from t2 order by id2;


create table trigger_actions1(id smallint auto_increment, info varchar);
create table trigger_actions2(id smallint auto_increment, info varchar);

create trigger trigg1 before update on t1 execute insert into trigger_actions1(info) values ('updated');
create trigger trigg2 after insert on t1 execute insert into trigger_actions1(info) values ('inserted');
create trigger trigg3 after delete on t1 execute insert into trigger_actions1(info) values ('deleted');
create trigger trigg4 before update on t2 execute insert into trigger_actions2(info) values ('updated');
create trigger trigg5 after insert on t2 execute insert into trigger_actions2(info) values ('inserted');

commit;




--TEST: error, set with a value that is out of the partition range.
merge into t1
using t2
on (t1.id1=t2.id2)
when matched then
update
set t1.col1=default, t1.col2='invalid';

--select if (count(*)=0, 'ok', 'nok') from t1 where col2='invalid';
select case when count(*)=0 then 'ok' else 'nok' end from trigger_actions1;

rollback;


--TEST: error, insert a value that is out of the partition range.
merge into t2
using t1
on (t1.id1=t2.id2)
when not matched then
insert
values('invalid', t1.id1);

select if (count(*)=0, 'ok', 'nok') from t2 where col1='invalid';
select case when count(*)=0 then 'ok' else 'nok' end from trigger_actions2;

rollback;



--TEST: update_clause only, 4 rows merged.
merge into t1
using t2
on (t1.id1=t2.id2)
when matched then
update
set t1.col1=default, t1.col2='updated';

select if (count(*)=4, 'ok', 'nok') from t1 where col2='updated';
select case when count(*)=4 then 'ok' else 'nok' end from trigger_actions1;

rollback;


--TEST: insert_clause only, 2 rows merged.
merge into t2
using t1
on (t1.id1=t2.id2)
when not matched then
insert
values('inserted', t1.id1);

select if (count(*)=14, 'ok', 'nok') from t2;
select if (count(*)=2, 'ok', 'nok') from t2 where col1='inserted';
select case when count(*)=2 then 'ok' else 'nok' end from trigger_actions2;

rollback;


--TEST: with both update and insert clause, 4 rows merged.
merge into t2
using t1
on (t1.id1=t2.id2)
when matched then
update
set t2.col1='updated'
where t1.col2 like 'mysql%'
when not matched then
insert
values('inserted', t1.id1);

select if (count(*)=14, 'ok', 'nok') from t2;
select if (count(*)=2, 'ok', 'nok') from t2 where col1='updated';
select if (count(*)=2, 'ok', 'nok') from t2 where col1='inserted';
select case when count(*)=4 then 'ok' else 'nok' end from trigger_actions2;

rollback;



--TEST: with both update and insert clause, 12 rows merged.
merge into t1
using t2
on (t1.id1=t2.id2)
when matched then
update
set t1.col2='updated'
when not matched then
insert
values(t2.id2, default, 'inserted');

select if (count(*)=14, 'ok', 'nok') from t1;
select if (count(*)=4, 'ok', 'nok') from t1 where col2='updated';
select if (count(*)=8, 'ok', 'nok') from t1 where col2='inserted';
select case when count(*)=12 then 'ok' else 'nok' end from trigger_actions1;

rollback;


-- ################################# CUBRID BUG: CUBRIDSUS-9186 ###########################i
--TEST: update+delete+insert, 12 rows merged
merge into t1
using t2
on (t1.id1=t2.id2)
when matched then
update
set t1.col2='updated'
delete where t1.col1 < '2011-09-01 12:12:16'
when not matched then
insert
values(t2.id2, default, 'inserted');

select if (count(*)=12, 'ok', 'nok') from t1;
select if (count(*)=2, 'ok', 'nok') from t1 where col2='updated';
select if (count(*)=8, 'ok', 'nok') from t1 where col2='inserted';
select case when count(*)=14 then 'ok' else 'nok' end from trigger_actions1;


drop trigger trigg1, trigg2, trigg3, trigg4, trigg5;
drop table t1, t2;
drop table trigger_actions1, trigger_actions2;
commit;


autocommit on;





