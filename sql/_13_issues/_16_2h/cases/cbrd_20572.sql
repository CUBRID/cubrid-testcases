drop table if exists t1, t2, t3;


create table t1(s1 varchar);
insert into t1 values(repeat('a',300));
select disk_size(s1), length(s1) from t1; 
select * from t1;
alter table t1 change s1 s1 char(300);
select disk_size(s1), length(s1) from t1; 
select * from t1;


create table t2(s1 varchar);
insert into t2 values(repeat('a',300));
select disk_size(s1), length(s1) from t2;
select * from t2;
alter table t2 change s1 s1 char(310);
select disk_size(s1), length(s1) from t2; 
select * from t2;


create table t3(s1 varchar);
insert into t3 values(repeat('a',300));
select disk_size(s1), length(s1) from t3;
select * from t3;
alter table t3 change s1 s1 char(200);
select disk_size(s1), length(s1) from t3; 
select * from t3;
