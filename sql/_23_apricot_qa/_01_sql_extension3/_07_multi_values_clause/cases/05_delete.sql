drop table if exists [test];
create table [test] (id int primary key, name string);
insert into [test] values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
select * from [test] order by 1;

--Positive
delete [test] from [test] inner join (values(1),(2)) as t(id) on [test].id=t.id;
select * from [test] order by 1;

delete from [test];
insert into [test] values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete from [test] inner join (values(1),(2)) as t(id) on [test].id=t.id;
select * from [test] order by 1;

delete from [test];
insert into [test] values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
delete [test] from [test] left join (values(1),(2)) as t(id) on [test].id=t.id;
select * from [test] order by 1;

delete from [test];
insert into [test] values(1,'name1'),(2,'name2'),(5,'name5'),(6,'name6');
delete from [test] using [test] inner join (values(1),(2)) as t(id) on [test].id=t.id;
select * from [test] order by 1;

--Negative
delete from [test];
insert into [test] values(1,'name1'),(2,'name2'),(5,'name5'),(6,'name6');
delete t from [test] inner join (values(1),(2)) as t(id) on [test].id=t.id;

delete from [test];
insert into [test] values(1,'name1'),(2,'name2'),(5,'name5'),(6,'name6');
delete from t using [test] inner join (values(1),(2)) as t(id) on [test].id=t.id;


drop table [test];