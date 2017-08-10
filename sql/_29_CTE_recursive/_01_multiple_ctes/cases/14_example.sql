drop table if exists stu,cource,score;
create table stu(id int,name varchar(50),description varchar(100));
insert into stu values(0001,'lilei','07 grade,computer');
insert into stu values(0002,'hameimei','07 grade,computer');
insert into stu values(0003,'rose','07 grade,computer');
create table cource(id int,name varchar(50),description varchar(100));
insert into cource values(1,'math','07');
insert into cource values(2,'language','07');
create table score(stu_id int,cource_id int,score double);
insert into score values(0001,1,98);
insert into score values(0001,2,60);
insert into score values(0002,1,88);
insert into score values (0002,2,80);
insert into score values(0003,1,48);
insert into score values(0003,2,100);
with recursive sum_stu as(
select count(id) as num from stu
),
 per_avg_score(id,avgscore) as(
select cource_id ,avg(score)  from score group by cource_id
)
select * from stu where id in 
 (select stu_id from score inner join per_avg_score on stu_id=id where score >avgscore);
 
  
with recursive stu_number_every_cource_id(id,nbr) as(
select cource_id, count(stu_id) from score group by cource_id
),
sum_score(id,sumscore) as(
select cource_id ,sum(score)  from score group by cource_id
),
avg_score(id,avgscore) as(
  select a.id,a.sumscore/b.nbr from sum_score a inner join stu_number_every_cource_id b on a.id=b.id
),
stu_score(stu_id,cource_id,score,avgscore) as (
select * from 
 (select stu_id,cource_id,score,avgscore from score inner join avg_score on cource_id=avg_score.id 
  where score.score >avgscore) x
)
select * from stu, stu_score where stu.id=stu_score.stu_id;
drop table if exists stu,cource,score;
