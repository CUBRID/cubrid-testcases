--TEST: [Merge Statement] Result of a merge statement is incorrect when autocommit mode is off.


autocommit off;

drop table if exists t1;
drop table if exists t2;


--server side
create table t1(id int, col1 char(10));
insert into t1(id, col1) values(1, 'aaa');

create table t2(id int, col1 char(10));
insert into t2 values(1, 'updated');

merge into t1
using t2
on (t2.id=t1.id)
when matched then
update
set t1.col1=t2.col1;

select * from t1 order by 1;

insert into t1 values(2, 'aaa');
insert into t2 values(2, 'updated');


--merge after insert
merge into t1
using t2
on (t2.id=t1.id)
when matched then
update
set t1.col1=t2.col1;

--check the result
select * from t1 order by 1;


drop table t1, t2;


--client side
create table t1(id int, col1 char(10));
insert into t1(id, col1) values(1, 'aaa');

create table t2(id int, col1 char(10));
insert into t2 values(1, 'updated');

create table trigger_actions(id smallint auto_increment, info varchar);
create trigger trigg1 before update on t1 execute insert into trigger_actions(info) values ('before update');

merge into t1
using t2
on (t2.id=t1.id)
when matched then
update
set t1.col1=t2.col1;

select * from t1 order by 1;

insert into t1 values(2, 'aaa');
insert into t2 values(2, 'updated');


--merge after insert
merge into t1
using t2
on (t2.id=t1.id)
when matched then
update
set t1.col1=t2.col1
where t1.id > 1;

--check the result
select * from t1 order by 1;
select * from trigger_actions order by 1;


drop table trigger_actions;
drop table t1, t2;


rollback;
autocommit on;
