--+ holdcas on;

drop table if exists t1;

drop table if exists t2;

create table t1(s1 string unique default repeat('a',500));   

create table t2(s1 char(500) unique default repeat('b',500));

-- test string compression(insert with select/multiple values clause/DEFAULT values/ODUC/REPLACE)

insert into t1 values(repeat('abc',50));

insert into t1 values(repeat('abc',100));

insert into t2 values(repeat('def',50));

insert into t2 values(repeat('def',100));

select s1,length(s1),disk_size(s1) from t1 order by 1;

select s1,length(s1),disk_size(s1) from t2 order by 1;

delete from t1;

delete from t2;

insert into t1 default values;

insert into t2 default values;

select s1,length(s1),disk_size(s1) from t1;

select s1,length(s1),disk_size(s1) from t2;

truncate t1;

truncate t2;

insert into t1 set s1=repeat('mn',50);  

insert into t1 set s1=repeat('mn',200);  

insert into t2 set s1=repeat('op',50);  

insert into t2 set s1=repeat('op',200);  

select s1,length(s1),disk_size(s1) from t1 order by 1;

select s1,length(s1),disk_size(s1) from t2 order by 1;

delete from t1;

insert into t1 select * from t2;

select s1,length(s1),disk_size(s1) from t1 order by 1;

insert into t1 values('a');

insert into t1 values('a') on duplicate key update s1=repeat('abc',100);

select s1,length(s1),disk_size(s1) from t1 where s1 like 'abc%';

truncate t1;

insert into t1 values(repeat('a',50)),(repeat('b',255)),(repeat('c',300));

replace into t1 values(repeat('d',254));

replace into t1 set s1='aa';

replace into t1 default values;

select s1,length(s1),disk_size(s1) from t1 order by 1;

truncate t1;

replace into t1 select * from t2;

select s1,length(s1),disk_size(s1) from t1 order by 1;

--- test string compression(update)

update t1 inner join t2 on t1.s1=t2.s1 set t1.s1=t1.s1+'123' where t1.s1>'a';

update t2 set s1=s1+'1' where s1>'c' order by s1; 

select s1,length(s1),disk_size(s1) from t1 order by 1;

select s1,length(s1),disk_size(s1) from t2 order by 1;

drop t1;

drop t2;


--+ holdcas off;