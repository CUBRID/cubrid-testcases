drop table if exists [test];
create table [test] (id int primary key, name string);
insert into [test] values(1,'name1'),(3,'name3'),(5,'name5'),(6,'name6');
select * from [test] order by 1;

delete from [test];
insert into [test] values(1,'name1'),(2,'name2'),(3,'name3');
insert into [test] values(4,'name1'),(5,'name2'),(6,'name3');
insert into [test] values(7,'name1'),(8,'name2'),(9,'name3'),(10,'name4'),(11,'name5');
select * from [test] order by 1;


delete from [test];
insert into [test] (id,name) values(1,'name12'),(2,'name22'),(3,'name32');
select * from [test] order by 1;

delete from [test];
insert into [test] (values(1,'name13'));
insert into [test] (values('2','name13'));
insert into [test] (values('0X2','name13'));
select * from [test] order by 1;

delete from [test];
insert into [test] (values(cast(1 as int),cast('name14' as string)),(2,'name24'));
select * from [test] order by 1;

delete from [test];
insert into [test] (select '1', 'name15');
select * from [test] order by 1;

delete from [test];
insert into [test] (values(cast(1 as int),cast('name14' as string)),(2,'name24'),(3,'name24'),(4,'name24'));
select * from [test] order by 1;

delete from [test];
insert into [test] values(1,'name1',4);
insert into [test] (values(1,'name1',5));

drop table [test] order by 1;
drop table [test];

