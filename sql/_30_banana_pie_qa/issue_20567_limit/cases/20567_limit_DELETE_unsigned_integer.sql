--+ holdcas on;

--LIMIT opt_limit_expr 

drop table if exists t;
create table t ( i int , j varchar(10));
--Insert 748 rows. 
insert into t select * from (select rownum, a.class_name from _db_class a , _db_class b where length(a.class_name)<=10 limit 10*100);


--Statement 1
delete from t  limit 4;

--Statement 2
delete from t  limit 1+3;

--Statement 3
delete from t  limit 8-4;

--Statement 4
delete from t  limit 2*2;

--Statement 5
delete from t  limit 12/3;

--Statement 6
delete from t  limit (1+3)+(8-4);

--Statement 7
delete from t  limit (1+3)-(8-4);

--Statement 8
delete from t  limit 7-(3-1)*2+1;

--Statement 9
delete from t  limit 1-(7-1)/3+5;

--Statement 10
delete from t  limit 3/2;

--Statement 11
delete from t  limit 2/3;

--Statement 12
delete from t  limit 2/0;

--Statement 13
delete from t  limit -4;

--Statement 14
delete from t  limit -(7-1)/3+5;

--Statement 15
delete from t  limit (-(7-1)/3+5);

--Statement 16
delete from t  limit (0-(7-1)/3+5);

--Statement 17
delete from t  limit 0-(7-1)/3;

--Statement 18
delete from t  limit 2*2*2*2*2*2; 

autocommit off;
--1024*1024*1024=2147483648
delete from t  limit 2147483648;
rollback;
delete from t  limit 1024*1024*1024-1+1024*1024*1024; 
rollback;
delete from t  limit 1024*1024*1024+1024*1024*1024-1; 
rollback;
delete from t  limit 9999999999999999999999999999999999999;
rollback;
delete from t  limit 4+'a';
rollback;
delete from t  limit 4+a;
rollback;
autocommit on;
drop table if exists t;

--+ holdcas off;

