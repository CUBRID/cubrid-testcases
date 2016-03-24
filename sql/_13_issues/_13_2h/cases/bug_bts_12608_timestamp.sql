--test cases from qa

--test: timestamp type column with function as default value
--1. LOCALTIME
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default LOCALTIME
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--2. CURRENT_TIMESTAMP()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default CURRENT_TIMESTAMP()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--3. CURRENT_TIMESTAMP
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default CURRENT_TIMESTAMP
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--4. SYS_TIMESTAMP
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default SYS_TIMESTAMP
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--5. SYSTIMESTAMP
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default SYSTIMESTAMP
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--6. LOCALTIME()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default LOCALTIME()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1;

--7. LOCALTIMESTAMP
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default LOCALTIMESTAMP
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1;

--8. LOCALTIMESTAMP()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c timestamp default LOCALTIMESTAMP()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1;

drop table t1;
