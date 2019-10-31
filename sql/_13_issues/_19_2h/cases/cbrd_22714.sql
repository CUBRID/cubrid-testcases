drop table if exists t1, t2;

create table t1 (id int primary key, title varchar(100));

create table t2 as
  WITH RECURSIVE cte AS ( 
    SELECT id, title FROM t1
    UNION ALL 
    SELECT id + 1, 'test title' FROM cte where id<10
  ) SELECT  * FROM cte;
  
drop table if exists t1, t2;
