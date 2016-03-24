drop table if exists t1,t2;

create table t1(a int, b int);
create table t2(a int default 999, b int);
insert into t1 values (1,2);

--result is good
merge into t2 using t1 on t1.a=t2.a when not matched then insert values (default(t2.a), 2);

--fail, throw "ERROR: System error (resolution) in ../../src/parser/name_resolution.c (line: 3123)"
merge into t2 using t1 on t1.a=t2.a when not matched then insert values (default(a), 2);

--result is good
merge into t2 using t1 on t1.a=t2.a when not matched then insert values (default, 2);
    
drop table if exists t1,t2;
