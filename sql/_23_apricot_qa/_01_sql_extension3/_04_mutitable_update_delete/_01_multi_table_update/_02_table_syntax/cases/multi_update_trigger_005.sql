--TEST: trigger action: multi-table delete operation.

autocommit on;

--TEST: before delete trigger action
create table t1(a int);
insert into t1 values(1), (2), (3), (4);

create table t2(b int);
insert into t2 values(2), (4), (6);

--TEST: create trigger
create trigger trigg1 before update on t1
execute delete t1, t2 from t1, t2 where t1.a=t2.b;

--TEST: trig the trigger
update t1, t2 set t1.a=6, t2.b=3 where t1.a=t2.b;
select if(a in {1, 3}, 'ok', 'nok') from t1;
select if(b=6, 'ok', 'nok') from t2;

drop table t1, t2;


--TEST: after delete trigger action
create table t1(a int);
insert into t1 values(1), (2), (3), (4);

create table t2(b int);
insert into t2 values(2), (4), (6);

--TEST: create trigger
create trigger trigg1 after update on t1
execute delete t1, t2 from t1, t2 where t1.a=t2.b;

--TEST: trig the trigger
update t1, t2 set t1.a=100, t2.b=200 where t1.a=t2.b;
select if(count(*)=1, 'ok', 'nok') from t1 where a=100;
select if(count(*)=1, 'ok', 'nok') from t2 where b=200;


drop table t1, t2;


--TEST: 1 table
create table foo(a int);
insert into foo values(1), (2), (3), (3), (3), (3);

create trigger trigg1 after update on foo
execute delete from foo where a=3;

update foo set a=100 where a=3;
select if(count(*)=1, 'ok', 'nok') from foo where a=100;

drop table foo;


--TEST: 1 table
create table foo(a int);
insert into foo values(1), (2), (3), (3), (3), (3), (3);

create trigger trigg1 before update on foo
execute delete from foo where a=3;

update foo set a=100 where a=3;
select if(count(*)=2, 'ok', 'nok') from foo;

drop table foo;


