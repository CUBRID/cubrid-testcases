--test cases from qa

--test: time type column with function as default value
--1. CURTIME()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c time default CURTIME()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--2. CURRENT_TIME()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c time default CURRENT_TIME()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--3. CURRENT_TIME
drop table if exists t1;
create table t1(
a int primary key,
b int,
c time default CURRENT_TIME
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--4. SYS_TIME
drop table if exists t1;
create table t1(
a int primary key,
b int,
c time default SYS_TIME
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--5. SYSTIME
drop table if exists t1;
create table t1(
a int primary key,
b int,
c time default SYSTIME
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

drop table t1;

