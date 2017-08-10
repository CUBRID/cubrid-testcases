-- [er]create two hash partition tables of size 16 and  one of using primary key of another table as foreign key and select ,update and delete data 

create table t27(id int primary key ) partition by hash(id) partitions 16; 

create table t26(id int , FOREIGN key(id) references t27(id) ) 
partition by hash(id) partitions 16; 

insert into t27 values(1); 
insert into t27 values(2); 
insert into t27 values(3); 


insert into t26(id) values(1); 
insert into t26(id) values(2); 
insert into t26(id) values(3); 

select * from t27 order by 1;
select id from t26 order by t26.id;
update t27 set id = 5 where id =2 ;
delete from t27 where id = 2 ;
select id  from t26 order by id;

delete from t27 where id = 2;

drop t26;
drop t27;
