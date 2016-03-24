--TEST: [Apricot BB] merge statement: ambiguous error in when not matched statement

drop table if exists t1;
drop table if exists t2;

CREATE TABLE t1 (x INT, y INT);
CREATE TABLE t2 (a INT, b INT, c int);

insert into t1 values(1, 1);
insert into t1 values(2, 2);
insert into t1 values(3, 3);

insert into t2 values(1, 10, 100);
insert into t2 values(2, 20, 200);
insert into t2 values(3, 30, 300);
insert into t2 values(4, 40, 400);
insert into t2 values(5, 50, 500);


--error
MERGE INTO t1 USING t2 ON t1.x = t2.a
WHEN MATCHED THEN 
     UPDATE SET t1.y = 100 
WHEN NOT MATCHED THEN 
    INSERT (x, y) VALUES (t1.x, t2.c);

--success
MERGE INTO t1 USING t2 ON t1.x = t2.a
WHEN MATCHED THEN 
     UPDATE SET t1.y = 100 
WHEN NOT MATCHED THEN 
    INSERT (x, y) VALUES (b, c);

select * from t1 order by 1;
drop table t1, t2;


create table t1 (a int, b int);
create table t2(a int, b int, c int);

insert into t1 values(1, 1);
insert into t1 values(2, 2);
insert into t1 values(3, 3);

insert into t2 values(1, 10, 100);
insert into t2 values(2, 20, 200);
insert into t2 values(3, 30, 300);
insert into t2 values(4, 40, 400);
insert into t2 values(5, 50, 500);


merge into t1 using t2 on (t1.a=t2.a)
when matched then
	update set t1.b=t2.c
when not matched then
	insert(b) values(b) where t2.a < 5;

select * from t1 order by 1;

merge into t1 using t2 on (t1.a=t2.a)
when matched then
        update set t1.b=t2.c
when not matched then
        insert(a, b) values(b, c);

select * from t1 order by 1;


drop table t1, t2;

