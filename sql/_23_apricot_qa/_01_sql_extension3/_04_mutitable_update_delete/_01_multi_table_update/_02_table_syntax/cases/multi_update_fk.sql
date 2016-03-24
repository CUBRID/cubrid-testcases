--update 2 tables, 1 of which has a foreign key reference


create table t1(id int primary key, phone varchar(20));

create table t2(id int primary key, 
name varchar(20) not null, 
constraint fk_id foreign key(id) references t1(id)
on update restrict);

insert into t1 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max');


create table t3(id int primary key, phone varchar(20));
create table t4(id int primary key, name varchar(20) not null);

insert into t3 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t4 values(1,'George'),(2,'Laura'),(3,'Max');

--TEST: create triggers
--!!!!!!!!!!!!!!!!!!!!CUBRID BUG: CUBRIDSUS-7203!!!!!!!!!!!!!!!!!!!!!
--create trigger trigg1 before update on t2 execute update t1 set phone='updated' limit 1;
create trigger trigg1 before update on t2 execute update t1 set phone='updated';
create trigger trigg2 before update on t1 execute update t3, t4 set t3.phone='updated1', t4.id=t3.id*t4.id where t3.id=t4.id;

--TEST: success, 1 row updated.
update t1, t2 set t2.id=t1.id+1 where t1.id=t2.id and t2.id=3;
--TEST: check update result
select if(id=4, 'ok', 'nok') from t2 where name='Max';
--TEST: check trigger result
select if(count(*)=5, 'ok', 'nok') from t1 where phone='updated';
select if(count(*)=4, 'ok', 'nok') from t3 where phone='updated1';
select if(count(*)=3, 'ok', 'nok') from t4 where id in {1, 9, 16};


--TEST: error, foreign key constraint error
update t1, t2 set t2.id=t1.id+2, t1.phone='updated', t1.id=t2.id*t1.id where t1.id=t2.id and t1.id=4;



drop trigger trigg1, trigg2;
drop table t3, t4, t2, t1;


