--+ holdcas on;

--LIMIT opt_limit_expr1 , opt_limit_expr2 ; 

drop table if exists t;
create table t ( i int , j varchar(10));
--Insert 15 rows
insert into t select rownum-2 , substring(class_name,0,10) from _db_class where class_name limit 2, 2*2*2*2-2/2; 
select * from t order by 1;

--Statement 1
select * from t order by 1, 2 limit 4,  1+3;

--Statement 2
select * from t order by 1, 2 limit 1+3,  8-4;

--Statement 3
select * from t order by 1, 2 limit 8-4,  2*2; 

--Statement 4
select * from t order by 1, 2 limit 2*2,  12/3; 

--Statement 5
select * from t order by 1, 2 limit 12/3,  (1+3)+(8-4);

--Statement 6
select * from t order by 1, 2 limit  10/2+1, 5-1; 

--Statement 7
select * from t order by 1, 2 limit (1+3)-(8-4),  (1+3)+(8-4);

--Statement 8
select * from t order by 1, 2 limit (1+3)-(8-4),  7-(3-1)*2+1;

--Statement 9
select * from t order by 1, 2 limit 7-(3-1)*2+1,  1-(7-1)/3+5;

--Statement 10
select * from t order by 1, 2 limit 1-(7-1)/3+5,  3/2;

--Statement 11
select * from t order by 1, 2 limit 3/2,  2/3;

--Statement 12
select * from t order by 1, 2 limit 2/3,  2/0;

--Statement 13
select * from t order by 1, 2 limit 2/0,  -4;

--Statement 14
select * from t order by 1, 2 limit -4,   -(7-1)/3+5;

--Statement 15
select * from t order by 1, 2 limit -(7-1)/3+5,   0-(7-1)/3;

--Statement 16
select * from t order by 1, 2 limit 0-(7-1)/3,   4;

--Statement 17
select * from t order by 1, 2 limit -2,    4;

--Statement 18
select * from t order by 1, 2 limit 2, 2*2*2*2; 

--Statement 19
select * from t order by 1, 2 limit 2, 1*2/3*4/5/1*2; 

--Statement 20
select * from t order by 1, 2 limit 2, 1*2*4*2/3/5/1; 


select * from t order by 1, 2 limit '',  1+3;
select * from t order by 1, 2 limit 4,  ' '+3;
select * from t order by 1, 2 limit null, null+null;


SELECT t1.* FROM (SELECT * FROM t AS t2 WHERE i > 5 order by 1 LIMIT 2+3 ) AS t1 LIMIT 5/4,3*2;
select * from t order by 1, 2 limit a-2,    4;
select * from t order by 1, 2 limit 2,    4*a;


drop table if exists t;

--+ holdcas off;

