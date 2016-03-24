--update 10 tables with 1 statement


drop table if exists t2, t1, t3, t4, t5, t6, t7, t8, t9, t10;

create table t1(id int, phone varchar(20)) 
partition by hash(id) partitions 20;

create table t2(id int , name varchar(20) not null)
partition by hash(id) partitions 20;

insert into t1 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max');


create table t3(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t3 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');


create table t4(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t4 values(1,'George'),(2,'Laura'),(3,'Max');


create table t5(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t5 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');


create table t6(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t6 values(1,'George'),(2,'Laura'),(3,'Max');



create table t7(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t7 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');


create table t8(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t8 values(1,'George'),(2,'Laura'),(3,'Max');



create table t9(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t9 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');


create table t10(id int , phone varchar(20)) 
partition by hash(id) partitions 20;
insert into t10 values(1,'George'),(2,'Laura'),(3,'Max');



select * from t2, t1, t3, t4, t5, t6, t7, t8, t9, t10 where t1.id=t2.id and t2.id=t3.id and t4.id=t5.id and t3.id=t5.id and t5.id=t6.id and t6.id=t7.id and t7.id=t8.id and t8.id=t9.id and t9.id=t10.id and t1.id=1;


--TEST: update 10 tables
update t2, t1, t3, t4, t5, t6, t7, t8, t9, t10 set t2.id=t1.id+1, t1.phone='updated', t3.phone='333', t4.phone='444', t5.phone='555', t6.phone='666', t7.phone='777', t8.id=888, t9.id=t1.id*t2.id*t5.id*t7.id*t9.id, t10.phone=t2.name+t4.phone+t6.phone where t1.id=t2.id and t2.id=t3.id and t4.id=t5.id and t3.id=t5.id and t5.id=t6.id and t6.id=t7.id and t7.id=t8.id and t8.id=t9.id and t9.id=t10.id;


--TEST: check update result
select if(count(*)=3, 'ok', 'nok') from t1 where phone='updated';
select if(id in (2, 3, 4), 'ok', 'nok') from t2;
select if(count(*)=3, 'ok', 'nok') from t3 where phone='333';
select if(count(*)=3, 'ok', 'nok') from t4 where phone='444';
select if(count(*)=3, 'ok', 'nok') from t5 where phone='555';
select if(count(*)=3, 'ok', 'nok') from t6 where phone='666';
select if(count(*)=3, 'ok', 'nok') from t7 where phone='777';
select if(count(*)=3, 'ok', 'nok') from t8 where id=888;
select if(count(*)=3, 'ok', 'nok') from t9 where id in (1, 32, 243);
select if(phone in ('MaxMaxMax', 'LauraLauraLaura', 'GeorgeGeorgeGeorge'), 'ok', 'nok') from t10;





drop table if exists t2, t1, t3, t4, t5, t6, t7, t8, t9, t10;







