--test: server crash when executing merge statement.

autocommit on;

--original repro scenario
create class foo(
a int primary key,
b int,
c timestamp default SYS_TIMESTAMP
);

MERGE INTO foo A 
USING db_root ON (A.a = 1) 
WHEN MATCHED THEN UPDATE SET A.b = A.b + 1 
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select a, b from foo order by 1;

drop table foo;

--1. default value test in insert clause
create class t1(
a int primary key,
b int,
c int default 0
);

merge into t1 A
using db_root on A.a=1
WHEN MATCHED THEN UPDATE SET c=default
WHEN NOT MATCHED THEN INSERT (A.a, A.b) VALUES(1, 1);

select * from t1 order by 1;

drop table t1;

create table t1(a int , b int default 0, c int auto_increment);
create table t2(a int , b int default 0);

insert into t1 values(1, 1, NULL);
insert into t2 values(1, 10);
insert into t2 values(2, 20);
insert into t2 values(3, 30);

--2. default value test in update clause
--3. auto increment value test in insert clause
merge into t1 using t2 on t1.a=t2.a
WHEN MATCHED THEN UPDATE SET t1.b=default, t1.c=100
WHEN NOT MATCHED THEN INSERT (t1.a, t1.b, t1.c) values(100, t2.b, NULL);

select * from t1 order by 1, 2, 3;

--4. default and auto increment value in insert clause
merge into t1 using t2 on t1.a=t2.a
WHEN MATCHED THEN UPDATE SET t1.b=t2.b, t1.c=NULL WHERE t1.b=0
WHEN NOT MATCHED THEN INSERT (t1.a) values(200);

select * from t1 order by 1, 2, 3;

delete from t2;
insert into t2 values(0, 20), (0, 30);

--5. DELETE test in update clause
merge into t1 using t2 on t1.b=t2.b
WHEN MATCHED THEN UPDATE SET t1.c=NULL WHERE t1.b< 30 DELETE WHERE t1.c is NULL
WHEN NOT MATCHED THEN INSERT (t1.a) values(300);

select * from t1 order by 1, 2, 3;

drop table t1;
drop table t2;


create table bar (a int primary key , b datetime default sysdatetime, c varchar(255) default current_user);

merge into bar A
using db_root on A.a=1
WHEN MATCHED THEN UPDATE SET b=default, c=default
WHEN NOT MATCHED THEN INSERT (A.a) VALUES(1);

select a from bar order by 1;

drop table bar;
