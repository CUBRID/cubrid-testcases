drop table if exists [test];
create table [test] (id int  primary key, name string);
insert into [test] values(1,'name1'),(3,'name3'),(5,'name5'),(6,'name6');
select * from [test] order by 1;

select (values(1));
select * from (select 1);

select (values(1)),(values(2));
select * from (select 1 ),(select 2);

--maybe a bug,0397 fixed
select (values(1,2,3));
select * from (select 1,2,3);

select (values(1,2,3));
select (select 1,2,3);
--

select * from (values(1,'default'),(2,'default'),(3,'default')) as t order by 1;
values(1,'default'),(2,'default'),(3,'default') order by 1;
select 1,'default' union all select 2,'default'  union all select 3,'default' order by 1;
select * from (values (1,'default'),(2,'default'),(3,'default')) order by 1;
select (values (1,'default'),(2,'default'),(3,'default')) order by 1;

select t.id from (values(1),(2),(3)) as t(id) order by 1;
select t.id from (values(1),(2),('3')) as t(id) order by 1;
select t.id from (values(1),(2),(3.5)) as t(id) order by 1;
select t.id from (values(1),(2),('3.5')) as t(id) order by 1;
select t.id from (select (1) union select (2) union select ('3.5')) as t(id) order by 1;
select t.id from (select (1) union select (2) union select (3.5)) as t(id) order by 1;

select t1.id, t2.name from (values(1),(2),(3)) as t1(id),(values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) where t1.id=t2.id order by 1;
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id),(values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) where t1.id=t2.id order by 1;
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id),(values(1,'name1'),(2,'name2'),(4,'name4'),(1,'name5')) as t2(id,name) where t1.id=t2.id order by 1;

select t1.id, t2.name from (values(1),(2),(3)) as t1(id) inner join (values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) on t1.id=t2.id order by 1; 
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id) inner join (values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) on t1.id=t2.id order by 1; 
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id) inner join (values(1,'name1'),(2,'name2'),(4,'name4'),(1,'name5')) as t2(id,name) on t1.id=t2.id order by 1; 

select t1.id, t2.name from (values(1),(2),(3)) as t1(id) left outer join (values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) on t1.id=t2.id order by 1;
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id) left outer join (values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) on t1.id=t2.id order by 1;
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id) left outer join (values(1,'name1'),(2,'name2'),(4,'name4'),(1,'name5')) as t2(id,name) on t1.id=t2.id order by 1;

select t1.id, t2.name from (values(1),(2),(3)) as t1(id) right outer join (values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) on t1.id=t2.id order by 1;
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id) right outer join (values(1,'name1'),(2,'name2'),(4,'name4')) as t2(id,name) on t1.id=t2.id order by 1;
select t1.id, t2.name from (values(1),(2),(3),(1)) as t1(id) right outer join (values(1,'name1'),(2,'name2'),(4,'name4'),(1,'name5')) as t2(id,name) on t1.id=t2.id order by 1;


select t2.id,t1.name from [test] as t1,(values(1),(2),(3),(4)) as t2(id) where t1.id=t2.id order by 1;
select t2.id,t1.name from [test] as t1,(values(1),(2),(3),(4),(1)) as t2(id) where t1.id=t2.id order by 1;
select t2.id,t1.name from [test] as t1 inner join (values(1),(2),(3),(4)) as t2(id) on t1.id=t2.id order by 1;
select t2.id,t1.name from [test] as t1 inner join (values(1),(2),(3),(4),(1)) as t2(id) on t1.id=t2.id order by 1;

select t2.id,t1.name from [test] as t1 left outer join (values(1),(2) ,(3),(4)) as t2(id) on t1.id=t2.id order by 1;
select t2.id,t1.name from [test] as t1 left outer join (values(1),(2) ,(3),(4),(1)) as t2(id) on t1.id=t2.id order by 1;

select t2.id,t1.name from [test] as t1 right outer join (values(1),(2),(3),(4)) as t2(id) on t1.id=t2.id order by 1;
select t2.id,t1.name from [test] as t1 right outer join (values(1),(2),(3),(4),(1)) as t2(id) on t1.id=t2.id order by 1;

select t1.id,t2.name from [test] as t2 inner join (values(1),(2),(3),(4)) as t1(id)  on t1.id=t2.id order by 1;
select t1.id,t2.name from [test] as t2 left outer join (values(1),(2),(3),(4)) as t1(id) on t1.id=t2.id order by 1;
select t1.id,t2.name from [test] as t2 right outer join (values(1),(2),(3),(4)) as t1(id)  on t1.id=t2.id order by 1;

drop table [test];