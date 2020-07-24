--+ holdcas on;

--LIMIT opt_limit_expr2 OFFSET opt_limit_expr1 ;

drop table if exists t;
create table t ( i int , j varchar(10));
--Insert 15 rows
insert into t select rownum-2, class_name from _db_class where length(class_name)<=10 limit 2*2*2*2-2/2 OFFSET 2;     
select * from t order by 1;

--Statement 1
select * from t order by 1, 2 limit 4  OFFSET  -(7-1)/3+5;

--Statement 2
select * from t order by 1, 2 limit 4  OFFSET  (7-1)/3+5;

--Statement 3
select * from t order by 1, 2 limit 1+3  OFFSET  0-(7-1)/3;

--Statement 4
select * from t order by 1, 2 limit 1+3  OFFSET  -2;

--Statement 5
select * from t order by 1, 2 limit 8-4  OFFSET  4;

--Statement 6
select * from t order by 1, 2 limit 2*2  OFFSET  1+3;

--Statement 7
select * from t order by 1, 2 limit 12/3  OFFSET  8-4;

--Statement 8
select * from t order by 1, 2 limit (1+3)+(8-4)   OFFSET  2*2;

--Statement 9
select * from t order by 1, 2 limit (1+3)-(8-4)  OFFSET  12/3;

--Statement 10
select * from t order by 1, 2 limit 7-(3-1)*2+1  OFFSET  (1+3)+(8-4);

--Statement 11
select * from t order by 1, 2 limit 1-(7-1)/3+5   OFFSET  (1+3)-(8-4);

--Statement 12
select * from t order by 1, 2 limit 3/2   OFFSET  7-(3-1)*2+1;

--Statement 13
select * from t order by 1, 2 limit 2/3   OFFSET  1-(7-1)/3+5;

--Statement 14
select * from t order by 1, 2 limit 2/0   OFFSET  3/2;

--Statement 15
select * from t order by 1, 2 limit -4   OFFSET  2/3; 

--Statement 16
select * from t order by 1, 2 limit -(7-1)/3+5   OFFSET   2/0;

--Statement 17
select * from t order by 1, 2 limit 0-(7-1)/3   OFFSET  -4; 

drop table if exists t;

--+ holdcas off;

