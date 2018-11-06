drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int);
insert into t2 values(3); 

WITH outer_subquery AS (
     SELECT a FROM t1
     )    
    SELECT *
    FROM t1 order by a, b;


WITH outer_subquery AS (
     SELECT a FROM t1
     )
delete FROM t1;
select * from t1 order by 1;

insert into t1
WITH outer_subquery AS (
     SELECT c,'fff' FROM t2
     )
SELECT c,'fff' FROM t2 order by 1,2;
select * from t1 order by 1;


replace into t1
WITH outer_subquery AS (
     SELECT c,'fff' FROM t2
     )
SELECT c,'fff' FROM t2 order by 1,2;
select * from t1 order by 1;

WITH outer_subquery AS (
     SELECT c,'fff' FROM t2
     )
update t2 set c=c+1 ;
select * from t2 order by 1;
drop if exists t1,t2;
