drop table if exists test;
create table test (id int primary key, name string);
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
select * from test; 
--Should check the table alias already exists
update test as t1,(values(1,'name1_n'),(2,'name2_n')) as t1(id1,name) set t1.name='updated' where t1.id=t1.id;
--Should check the table alias already exists
update test as t1,(select 1,'name1_n') as t1(id,name) set t1.name='updated' where t1.id=t1.id;
--Should check the table alias already exists
update test as t1,(select * from test) as t1(id,name) set t1.name='updated' where t1.id=t1.id;

drop table if exists test;