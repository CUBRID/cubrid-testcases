--TEST: [Merge Statement] delete_clause cannot work well when using a subquery of the target table as the source table.

drop table if exists t1;

create table t1(a int, b int, c int);
insert into t1 values(1, 1, 1);
insert into t1 values(2, 2, 2);
insert into t1 values(3, 3, 3);


--Temporary fix: don't allow target to be used in source spec.
merge into t1 using (select * from t1 where b<3) t2 
on (floor(t1.a)=t2.a) 
when matched then update set t1.b=1000 
delete where t1.a>1;

--fail because of temporary fix of this issue. it will succeed after CUBRIDSUS-9158 is fixed.
select if(count(*)=2, 'ok', 'nok') from t1;


merge into t1 using (select * from t1 where b<0) s
on (t1.a=s.a)
when matched then update set t1.b=789456
when not matched then insert values(111, 999, 999);


drop table t1;
