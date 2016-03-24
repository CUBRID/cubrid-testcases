--target table with foreign key constraint on server side

autocommit off;


create table t1(id int primary key, phone varchar(20));

create table t2(id int primary key, 
name varchar(20) not null, 
constraint fk_id foreign key(id) references t1(id)
on update restrict);

insert into t1 values(1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, '444-4444'), (5, '555-5555');
insert into t2 values(1,'George'),(2,'Laura'),(3,'Max');


commit;



-- ######################### CASE 1 ############################### --
--TEST: merge table with pk into table with fk
merge into t2
using t1
on (t1.id=t2.id)
when matched then
update
set t2.name=t1.phone
where t2.id < 3
delete where t2.id=2;

--TEST: check update result
select if(count(*)=2, 'ok', 'nok') from t2;
select * from t1 order by 1;
select * from t2 order by 1;

rollback;


-- ######################### CASE 2 ############################### --

--TEST: error, foreign key constraint error in delete clause
merge into t1
using t2
on (t1.id=t2.id)
when matched then
update
set t1.phone=t2.name
where t1.id > 0 and t2.id < 10
delete where t1.id=2
when not matched then
insert
values(t2.id, t2.name);

--TEST: check the result
select if(count(*)=0, 'ok', 'nok') from t1 where phone in (select name from t2);
select if(count(*)=5, 'ok', 'nok') from t1;

rollback;


--TEST: error, foreign key constraint error in insert clause
merge into t2
using t1
on (t2.id=t1.id)
when matched then
update
set t2.name=t1.phone
delete where t2.id > 2
when not matched then
insert
values(t1.id+1, t1.phone);

--TEST: check the result
select * from t2;
select if(count(*)=3, 'ok', 'nok') from t2;
select if(count(*)=0, 'ok', 'nok') from t2 where name in (select phone from t1);


rollback;



drop table t2, t1;
commit;



autocommit on;
