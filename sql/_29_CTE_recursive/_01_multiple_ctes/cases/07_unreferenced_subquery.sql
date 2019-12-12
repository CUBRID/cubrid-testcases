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
drop if exists t1,t2;
