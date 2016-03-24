--TEST:  [Multi-table Update] Select result is incorrect after updating 2 hash partition tables.


create table t1(id int, phone varchar(20)) 
partition by hash(id) partitions 5;

create table t2(id int , name varchar(20))
partition by hash(id) partitions 5;

insert into t1 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max'), (7, 'aaa'), (8, 'bbb');

update t1, t2 set t1.id=100, t2.id=200 where t1.id=t2.id;

select * from t2 order by 1, 2;
select * from t2 where id=200 order by 1, 2;
select * from t1 where id=100 order by 1, 2;


update t1, t2 set t1.phone='updated', t2.name='updated' where t1.id != t2.id and t1.id < 100 and t2.id < 100;

select * from t2 order by 1, 2;
select * from t2 where id=200 order by 1, 2;
select * from t1 where id=100 order by 1, 2;
select * from t2 where name='updated' order by 1, 2;
select * from t1 where phone='updated' order by 1, 2;


drop t1;
drop t2;
