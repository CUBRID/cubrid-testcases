drop table if exists t1;
create table t1 (a int, b int);
create unique index idx1 on t1 (a, b);
create trigger tr1 after insert on t1 execute print 't1 inserted';
insert into t1 values (1, NULL),(2,NULL);
insert into t1 values (1, NULL) on duplicate key update a = a + 10;
replace into t1 set a = 2 , b = null ;
select * from t1 order by a;
drop table t1;

create table t1 (a varchar(10), b varchar(10));
create unique index idx1 on t1 (a, b);
create trigger tr1 after insert on t1 execute print 't1 inserted';
insert into t1 values ('aa', NULL),('bb',NULL);
insert into t1 values ('aa', NULL) on duplicate key update a =concat(a,'new');
replace into t1 set a = 'bb' , b = null ;
select * from t1 order by a;
drop table t1;

drop table if exists t1; 
create table t1 (a bigint, b bigint);
create unique index idx1 on t1 (a, b); 
create trigger tr1 after insert on t1 execute print 't1 inserted';
insert into t1 values (1, NULL),(2,NULL);
insert into t1 values (1, NULL) on duplicate key update a = a + 10; 
replace into t1 set a = 2 , b = null ;
select * from t1 order by a;
drop table t1; 

drop table if exists t1; 
create table t1 (a time, b time);
create unique index idx1 on t1 (a, b); 
create trigger tr1 after insert on t1 execute print 't1 inserted';
insert into t1 values ('11:11:11', NULL),('12:12:12',NULL);
insert into t1 values ('11:11:11', NULL) on duplicate key update a = a + 10; 
replace into t1 set a = '12:12:12' , b = null ;
select * from t1 order by a;
drop table t1; 

drop table if exists t1;

drop table if exists t2;
create table t1 (a int, b int);
create table t2 (a int, b int);
create unique index idx1 on t1 (a, b); 
create unique index idx1 on t2 (a, b);
create trigger tr1 after insert on t1 execute insert into t2 values (obj.a,obj.b) on duplicate key update a = a + 10;
insert into t2 values(1, NULL),(2,NULL);
insert into t1 values(1,null);
select * from t2 order by a;
drop trigger tr1;
create trigger tr2 after insert on t1 execute replace into t2 set a = obj.a, b = obj.b;
insert into t1 values(2,null);
select * from t2 order by a;
drop table t2;
drop table t1; 

