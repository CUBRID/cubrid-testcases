drop table if exists [test];
create table [test] (id int primary key, name string);
insert into [test] values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
select * from [test] order by 1;

update [test] as t1,(values(1,'name1_n'),(2,'name2_n')) as t2(id,name) set t1.name=t2.name where t1.id=t2.id;
select * from [test] order by 1;
update (values(1,'name1_n'),(2,'name2_n')) as t2(id,name),[test] as t1 set t1.name=t2.name where t1.id=t2.id;
select * from [test] order by 1;

update [test] as t1 inner join (values(1,'name1_m'),(2,'name2_m')) as t2(id,name) on t1.id=t2.id set t1.name=t2.name;
select * from [test] order by 1;

update (values(1,'name1_m'),(2,'name2_m')) as t2(id,name) inner join [test] as t1 on t1.id=t2.id set t1.name=t2.name;
select * from [test] order by 1;
update (values(1,'name1_l'),(2,'name2_l')) as t1(id,name), [test] as t2 set t2.name=t1.name where t1.id=t2.id;
select * from [test] order by 1;
update (values(1,'name1_p'),(2,'name2_p')) as t1(id,name) inner join [test] as t2 on t1.id=t2.id set t2.name=t1.name;
select * from [test] order by 1;

update (values(1,'name1_p'),(2,'name2_p')) as t1(id,name) left join [test] as t2 on t1.id=t2.id set t2.name=t1.name;
select * from [test] order by 1;
update (values(1,'name1_p'),(2,'name2_p'),(5,'name2_p')) as t1(id,name) left join [test] as t2 on t1.id=t2.id set t2.name=t1.name;
select * from [test] order by 1;

update (values(1,'name1_p'),(2,'name2_p')) as t1(id,name) right join [test] as t2 on t1.id=t2.id set t2.name=t1.name;
select * from [test] order by 1;
update (values(1,'name1_p'),(2,'name2_p'),(5,'name2_p')) as t1(id,name) right join [test] as t2 on t1.id=t2.id set t2.name=t1.name;
select * from [test] order by 1;


update [test] as t1,(values(1,'name1_n'),(2,'name2_n')) as t2(id,name) set t2.name=t1.name where t1.id=t2.id;

update [test] as t1 inner join (values(1,'name1_n'),(2,'name2_n')) as t2(id,name) on t1.id=t2.id set t2.name=t1.name;

update (values(1,'name1_n'),(2,'name2_n')) as t1(id,name), [test] as t2 set t1.name=t2.name where t1.id=t2.id;

update (values(1,'name1_n'),(2,'name2_n')) as t1(id,name) inner join [test] as t2 on t1.id=t2.id set t1.name=t2.name;


drop table [test];