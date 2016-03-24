--test cases from qa

--test: string type column with function as default value
--1. CURRENT_USER
drop table if exists t1;
create table t1(
a int primary key,
b int,
c char(10) default CURRENT_USER
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c='a'
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--2. USER
drop table if exists t1;
create table t1(
a int primary key,
b int,
c varchar(20) default USER
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--3. DATABASE()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c varchar default DATABASE()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--4. SCHEMA()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c varchar(20) default SCHEMA()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

--5. USER()
drop table if exists t1;
create table t1(
a int primary key,
b int,
c string default USER()
);

merge into t1 A
using db_root B on (A.a=1)
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from t1 order by 1; 

drop table t1;

