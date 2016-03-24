--TEST: [Merge Statement] merge_update_clause does not rollback when there is a unique constraint violation error occurred in the merge_insert_clause.

autocommit on;

--server side
create table t1(a int unique, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');

create table t2(a int, b char(10));
insert into t2 values(1, 'updated');
insert into t2 values(2, 'updated');
insert into t2 values(3, 'inserted');

--[er]
merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.b=t2.b
when not matched then
insert
values(t2.a-1, t2.b);

--check the result
select * from t1 order by 1;

alter table t1 change b b char(10) unique;
--[er]
merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.b=t2.b
when not matched then
insert
values(t2.a-1, t2.b);

--check the result
select * from t1 order by 1;

drop table t1, t2;


--client side
create table t1(a int unique, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');

create table t2(a int, b char(10));
insert into t2 values(1, 'updated');
insert into t2 values(2, 'updated');
insert into t2 values(3, 'inserted');

create table actions(a int primary key auto_increment, b char(10));
create trigger trigg1 before update on t1 execute insert into actions(b) values('updated');
create trigger trigg2 before insert on t1 execute insert into actions(b) values('inserted');

--[er]
merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.b=t2.b
when not matched then
insert
values(t2.a-1, t2.b);

--check the result
select * from t1 order by 1;
select if(count(*)=0, 'ok', 'nok') from actions;

--[er]
alter table t1 change b b char(10) unique;
merge into t1
using t2
on (t2.a=t1.a)
when matched then
update
set t1.b=t2.b
when not matched then
insert
values(t2.a-1, t2.b);

--check the result
select * from t1 order by 1;
select if(count(*)=0, 'ok', 'nok') from actions;

drop trigger trigg1, trigg2;
drop table t1, t2, actions;








