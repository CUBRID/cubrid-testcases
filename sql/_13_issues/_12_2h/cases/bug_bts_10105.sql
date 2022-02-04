
drop table if exists t1,t2;

create table t2 as select 1 a union select 2 a;
select * from t2;

CREATE TABLE T1 AS SELECT '1' A UNION SELECT '2' A;
--test:fail. we expect it will be successful.
select * from t1;

drop table if exists t1,t2;

create table t2 as SELECT '1' A UNION SELECT '2 ' A UNION SELECT '3 ' A UNION SELECT '4 ' A;
SELECT '1' A UNION SELECT '2 ' A UNION SELECT '3 ' A UNION SELECT '4 ' A ;

select * from t2;

drop table if exists t1,t2;

create table t2 as SELECT '1' A UNION SELECT '2 ' A UNION SELECT '3 ' A UNION SELECT '4 ' A;
SELECT '1' A UNION SELECT '2 ' A UNION SELECT '3 ' A UNION SELECT '4 ' A  UNION SELECT '2 ' A UNION SELECT '3 ' A UNION SELECT '4 ' A;  
SELECT '1' A UNION SELECT '2 ' A UNION SELECT '3 ' A UNION SELECT '4 ' A ;

select * from t2;

drop table if exists t1,t2;

CREATE TABLE T1 AS SELECT '1' A UNION SELECT '2' A;

select * from t1;

drop table if exists t1,t2;

CREATE TABLE T1 AS SELECT '1' A UNION SELECT '2' A;

select * from t1;

drop table if exists t1,t2;
