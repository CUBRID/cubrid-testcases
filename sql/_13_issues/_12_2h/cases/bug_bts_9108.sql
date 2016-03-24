--TEST: [Merge Statement] Columns in the target table cannot be updated without the table name in the update_clause of a merge statement.


drop table if exists t1, t2;


--server side
create table t1(a int , b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(3, 'CCC');


--error
merge into t1 using t2 on (t1.a=t2.a)
when matched then 
update set b=b;


--should success
merge into t1 using t2 on (t1.a=t2.a)
when matched then 
update set b=t2.b;

select * from t1 order by 1;


--should success
merge into t1 using t2 on (t1.a=t2.a)
when matched then 
update set b=t2.b
delete where t2.b < 'BBB';

select * from t1 order by 1;

drop table t1, t2;



--client side
create table t1(a int , b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(3, 'CCC');

create table actions(id int auto_increment, info string);
create trigger trig1 before update on t1 execute insert into actions(info) values('updated');
create trigger trig2 before delete on t1 execute insert into actions(info) values('delete');

--error
merge into t1 using t2 on (t1.a=t2.a)
when matched then 
update set b=b;


--should success
merge into t1 using t2 on (t1.a=t2.a)
when matched then 
update set b=t2.b;

select * from t1 order by 1;
select if(count(*)=3, 'ok', 'nok') from actions;

--should success
merge into t1 using t2 on (t1.a=t2.a)
when matched then 
update set b=t2.b
delete where t2.b < 'BBB';

select * from t1 order by 1;
select if(count(*)=7, 'ok', 'nok') from actions;

drop table t1, t2, actions;
