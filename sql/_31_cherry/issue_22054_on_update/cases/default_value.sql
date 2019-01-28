drop table if exists t;
create table t(a int , b date default current_datetime on update current_datetime);
insert into  t(a) values(1);  
select if(b is not null,'ok','nok') from t;
update t set a=1;
select if(b is not null ,'ok','nok') from t;
alter table t modify b timestamp on update current_timestamp;  
update t set a=1;
select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t;
update t set b=default;
select * from t;


drop table if exists t;
create table t(a int , b timestamp default current_timestamp on update current_timestamp);
insert into  t(a) values(1);
select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t;
set @a=(select b from t);
select sleep(5);
update t set a=1;
select if(b-@a>=5 and current_timestamp-b<10,'ok','nok') from t;
update t set b=default;
select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t; 

drop table if exists t;
create table t(a int , b timestamp default '2018-09-19 15:00:00' on update current_timestamp);
insert into  t(a) values(1);
select * from t;
update t set b=default;
select * from t;

drop table if exists t;
create table t(a int , b timestamp on update current_timestamp);
insert into  t(a) values(1);
select * from t;
update t set b=default;
select * from t;

drop table if exists t;
create table t(
a int , 
b timestamp on update current_timestamp,
c timestamp on update current_timestamp);
insert into  t(a,b) values(1,'2018-07-31 15:38:00');
select * from t;
update t set b=default;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from t;
select if(b is null,'ok','nok') from t;


drop table if exists t;
create table t(a int default 0 , b timestamp on update current_timestamp);
insert into  t(a) values(1);
select if(b is null,'ok','nok') from t;
update t set a=default;
select if(b is not null,'ok','nok') from t;
drop table t;
drop variable @a;
