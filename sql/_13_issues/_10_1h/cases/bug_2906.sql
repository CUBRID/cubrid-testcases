create table t1(id int auto_increment, name varchar(80));
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from t1 order by 1;

delete from t1 where name = 'John';
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from t1 order by 1; 

drop table t1;


create table t1(id int not null auto_increment, name varchar(80));
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from t1 order by 1; 

delete from t1 where name = 'John';
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from t1 order by 1; 

drop table t1;



create class t1(id int auto_increment, name varchar(80));
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from t1 order by 1;

create vclass vt1(id int, name varchar(80)) as select * from t1;
select * from vt1 order by 1; 

delete from t1 where name = 'John';
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from vt1 order by 1; 

drop vclass vt1;
drop class t1;


create class t1(id int not null auto_increment, name varchar(80));
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from t1 order by 1; 

create vclass vt1(id int , name varchar(80)) as select * from t1;
select * from vt1 order by 1; 

delete from t1 where name = 'John';
insert into t1 values (null,'John'), (null,'Tom'), (null,'Bill');
select * from vt1 order by 1; 

drop vclass vt1;
drop class t1;


