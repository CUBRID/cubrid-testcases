create table t(i int);
insert into t values(-2147483648),(1);
select bit_and(i) from t; 
select bit_or(i) from t;
delete from t;
insert into t values(2147483647),(1);
select bit_and(i) from t; 
select bit_or(i) from t; 
drop t;

create table t(i smallint);
insert into t values(-32768),(1);
select bit_and(i) from t;
select bit_or(i) from t;
delete from t;
insert into t values(32767),(1);
select bit_and(i) from t; 
select bit_or(i) from t;  
drop t;