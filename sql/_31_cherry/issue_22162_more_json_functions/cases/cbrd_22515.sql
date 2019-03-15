-- http://jira.cubrid.org/browse/CBRD-22515

drop table if exists t1;

create table t1(a int, b int, c int);
insert into t1 values(1, 1, 1);
insert into t1 values(2, 2, 2);
insert into t1 values(3, 3, 3);

--core dump
merge into t1 using (select jt.a, b,c from json_table('{"a":[1,2]}', '$' columns( a int path '$.a[0]' )) as jt,  t1 where b>0 ) s
on (t1.a=s.a)
when matched then update set t1.b=789456
when not matched then insert values(111, 999, 999);

drop table if exists t1;

