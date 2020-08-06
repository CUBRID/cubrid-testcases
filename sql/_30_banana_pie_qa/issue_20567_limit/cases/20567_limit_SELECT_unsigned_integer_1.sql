--+ holdcas on;

--LIMIT opt_limit_expr 

drop table if exists t;
create table t ( i int , j varchar(10));
--Insert 15 rows. 
insert into t select rownum, substring(class_name,0,10) from _db_class where class_name limit 2*2*2*2-2/2;       
select * from t order by 1;


--Statement 1
select * from t order by 1, 2 limit 4;

--Statement 2
select * from t order by 1, 2 limit 1+3;

--Statement 3
select * from t order by 1, 2 limit 8-4;

--Statement 4
select * from t order by 1, 2 limit 2*2;

--Statement 5
select * from t order by 1, 2 limit 12/3;

--Statement 6
select * from t order by 1, 2 limit (1+3)+(8-4);

--Statement 7
select * from t order by 1, 2 limit (1+3)-(8-4);

--Statement 8
select * from t order by 1, 2 limit 7-(3-1)*2+1;

--Statement 9
select * from t order by 1, 2 limit 1-(7-1)/3+5;

--Statement 10
select * from t order by 1, 2 limit 3/2;

--Statement 11
select * from t order by 1, 2 limit 2/3;

--Statement 12
select * from t order by 1, 2 limit 2/0;

--Statement 13
select * from t order by 1, 2 limit -4;

--Statement 14
select * from t order by 1, 2 limit -(7-1)/3+5;

--Statement 15
select * from t order by 1, 2 limit (-(7-1)/3+5);

--Statement 16
select * from t order by 1, 2 limit (0-(7-1)/3+5);

--Statement 17
select * from t order by 1, 2 limit 0-(7-1)/3;

--Statement 18
select * from t order by 1, 2 limit 2*2*2*2*2*2; 

--1024*1024*1024=2147483648
select * from t order by 1, 2 limit 2147483648;
select * from t order by 1, 2 limit 1024*1024*1024-1+1024*1024*1024; 
select * from t order by 1, 2 limit 1024*1024*1024+1024*1024*1024-1; 
select * from t order by 1, 2 limit 9999999999999999999999999999999999999;
select * from t order by 1, 2 limit 4+'a';
select * from t order by 1, 2 limit 4+a;

drop table if exists t;

--+ holdcas off;

