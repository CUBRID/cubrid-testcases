--TEST: [Merge Statement] Merge statement will throw core file when with SERIAL (in pt_to_regu_variable at ../../src/parser/xasl_generation.c:9029)

drop table if exists t1, t2;

CREATE TABLE t1 (a int primary key,b int,c int );
CREATE TABLE t2 (a int primary key ,b int,c int );

insert into t1 values(1, 1, 1);
insert into t1 values(2, 2, 2);
insert into t1 values(3, 3, 3);

insert into t2 values(1, 1, 1);
insert into t2 values(2, 2, 2);
insert into t2 values(3, 3, 3);
insert into t2 values(4, 4, 4);

create serial s start with 100;

merge into t1 using  t2 on  (t1.a=t2.a) 
when matched then update set t1.b=s.next_value+1,t1.c=s.next_value+1;

select b,c from t1 order by 1;

delete from t1;
insert into t1 values(1, 101, 102);
insert into t1 values(2, 103, 104);
insert into t1 values(3, 105, 106);

merge into t1 using t2 on  (t1.a=t2.a) 
when matched then update set t1.b=s.next_value+1,t1.c=s.next_value+1
delete where t1.c<s.next_value and t1.a=1
when not matched then insert values(s.next_value*t2.a, s.next_value*t2.b, s.next_value*t2.c);

select b,c from t1 order by 1;

drop serial s;
drop table t1, t2;
