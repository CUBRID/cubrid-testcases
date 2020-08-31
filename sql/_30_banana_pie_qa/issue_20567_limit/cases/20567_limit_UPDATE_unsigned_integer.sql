--+ holdcas on;

--LIMIT opt_limit_expr 

drop table if exists t;
create table t ( i int , j varchar(10));
--Insert 15 rows. 
insert into t select rownum, substring(class_name,0,10) from _db_class where class_name limit 2*2*2*2-2/2;       
select * from t order by 1;


--Statement 1
update t set i = i + 100 order by i limit 4;

--Statement 2
update t set i = i + 100 order by i limit 1+3;

--Statement 3
update t set i = i + 100 order by i limit 8-4;

--Statement 4
update t set i = i + 100 order by i limit 2*2;

--Statement 5
update t set i = i + 100 order by i limit 12/3;

--Statement 6
update t set i = i + 100 order by i limit (1+3)+(8-4);

--Statement 7
update t set i = i + 100 order by i limit (1+3)-(8-4);

--Statement 8
update t set i = i + 100 order by i limit 7-(3-1)*2+1;

--Statement 9
update t set i = i + 100 order by i limit 1-(7-1)/3+5;

--Statement 10
update t set i = i + 100 order by i limit 3/2;

--Statement 11
update t set i = i + 100 order by i limit 2/3;

--Statement 12
update t set i = i + 100 order by i limit 2/0;

--Statement 13
update t set i = i + 100 order by i limit -4;

--Statement 14
update t set i = i + 100 order by i limit -(7-1)/3+5;

--Statement 15
update t set i = i + 100 order by i limit (-(7-1)/3+5);

--Statement 16
update t set i = i + 100 order by i limit (0-(7-1)/3+5);

--Statement 17
update t set i = i + 100 order by i limit 0-(7-1)/3;

--Statement 18
update t set i = i + 100 order by i limit 2*2*2*2*2*2; 

--1024*1024*1024=2147483648
update t set i = i + 100 order by i limit 2147483648;
update t set i = i + 100 order by i limit 1024*1024*1024-1+1024*1024*1024; 
update t set i = i + 100 order by i limit 1024*1024*1024+1024*1024*1024-1; 
update t set i = i + 100 order by i limit 9999999999999999999999999999999999999;
update t set i = i + 100 order by i limit 4+'a';
update t set i = i + 100 order by i limit 4+a;

drop table if exists t;

--+ holdcas off;

