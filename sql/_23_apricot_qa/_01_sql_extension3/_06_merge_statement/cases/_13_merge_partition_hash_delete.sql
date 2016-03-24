--merge into hash partition table


autocommit off;

create table t1(id1 double, col1 timestamp not null default CURRENT_TIMESTAMP, col2 string)
partition by hash(col1) partitions 10;
insert into t1(id1, col1) values(1111111.11111, '2011-09-01 12:12:12'), (2222222.22222, '2011-09-01 12:12:13'), (33333333.33333, '2011-09-01 12:12:14'), (4444444.44444, '2011-09-01 12:12:15'), (5555555.55555, '2011-09-01 12:12:16'), (6666666.66666, '2011-09-01 12:12:17'), (7777777.77777, '2011-10-10 1:1:1'), (8888888.88888, '2011-10-10 2:2:2'), (9999999.99999, '2011-11-11 11:11:11'), (1010101010.123, '2012-12-12 8:8:8');


create table t2(col1 varchar(1024), id2 double, primary key(col1, id2))
partition by hash(col1) partitions 20;
insert into t2 values('cubrid', 1234.12345), ('abc', 3333333456.34555), ('a', 55555.55555), ('abcabc', 4444444.12345), ('aa', 5555.1234), ('mysql', 2222222.22222);
insert into t2 values('cubridcubrid', 666.6666), ('mysqlmysql', 44444.44444444), ('aaaa', 5555656.56565), ('abcabcabc', 6666666.66666), ('hello', 777777777.88777), ('hellohello', 90000.909);


select * from t1 order by 1;
select * from t2 order by 1;


create table trigger_actions1(id smallint auto_increment, info varchar);
create table trigger_actions2(id smallint auto_increment, info varchar);

create trigger trigg1 before update on t1 execute insert into trigger_actions1(info) values ('updated');
create trigger trigg2 after insert on t1 execute insert into trigger_actions1(info) values ('inserted');
create trigger trigg3 before delete on t1 execute insert into trigger_actions1(info) values ('deleted');
create trigger trigg4 before update on t2 execute insert into trigger_actions2(info) values ('updated');
create trigger trigg5 after insert on t2 execute insert into trigger_actions2(info) values ('inserted');
create trigger trigg6 after delete on t2 execute insert into trigger_actions2(info) values ('deleted');


commit;


--TEST: merge into a hash partition table, 12 rows merged. 
merge into t1
using t2
on (t1.id1=t2.id2)
when matched then
update
set t1.col2=t2.col1, t1.col1=adddate(t1.col1, 10)
delete where t2.col1='mysql'
when not matched then
insert
values(t2.id2, '1971-11-11 11:11:11', t2.col1);


select if (count(*)=19, 'ok', 'nok') from t1;
select if (count(*)=13, 'ok', 'nok') from trigger_actions1;

rollback;



--TEST: merge into a hash partition table.
merge into t2
using t1
on (t1.id1=t2.id2)
when matched then
update
set t2.col1='updated'
where t1.id1 > 0
delete where t1.id1 < 10000000
when not matched then
insert
values('inserted', t1.id1)
where year(t1.col1)=2011;

select if (count(*)=17, 'ok', 'nok') from t2;
select if (count(*)=11, 'ok', 'nok') from trigger_actions2;



drop trigger trigg1, trigg2, trigg3, trigg4;
drop table t1, t2;
drop trigger_actions1, trigger_actions2;
commit;


autocommit on;





