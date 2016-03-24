--test cases from qa

--test: date type column with function as default value
--1. CURDATE()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c date default CURDATE()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--2. CURRENT_DATE()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c date default CURRENT_DATE()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--3. CURRENT_DATE
drop table if exists t1;
create table t1(
a int primary key,
b int,
c date default CURRENT_DATE
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--4. SYS_DATE
drop table if exists t1;
create table t1(
a int primary key,
b int,
c date default SYS_DATE
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--5. SYSDATE
drop table if exists t1;
create table t1(
a int primary key,
b int,
c date default SYSDATE
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

drop table t1;

