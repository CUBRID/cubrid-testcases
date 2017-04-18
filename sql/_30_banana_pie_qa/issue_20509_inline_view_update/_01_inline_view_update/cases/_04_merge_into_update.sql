-- TEST CASE For:
-- [CBRD-20509] Inline View Update : update by using merge into (inline view) 

drop table if exists t1;
drop table if exists t2;

create table t1(f1 int, f2 int);
create table t2(f1 int, f2 int);

insert into t1 values(1,1);
insert into t2 values(1,1), (2,2);

--[OK] merge into update: allowed 
merge into t2 using t1 on(t2.f1 =  t1.f1)     when matched then update set t2.f2 = t2.f2 + 1;
select * from t2;
merge into t2 using t1 on(t2.f1 =  t1.f1)     when matched then update set t2.f2 = t2.f2 + 1     when not matched then insert(t2.f1,t2.f2) values (t1.f1, t1.f2);
select * from t2;
merge into t2 using (select * from t1) t1 on(t2.f1 = 1)      when matched then update set t2.f2 = t2.f2 + 1     when not matched then insert(t2.f1,t2.f2) values (t1.f1, t1.f2);
select * from t2;
merge into t2 using t1 on(t2.f1 =  t1.f1)     when matched then update set t2.f2 = t2.f2 + 1   delete where t2.f1 >= 2;
select * from t2;
merge into t2 t22 using t1 on(t22.f1 =  t1.f1)     when matched then update set t22.f2 = t22.f2 + 1   delete where t22.f1 >= 2;
select * from t2;

--[NOK] inline view merge into update: not allowed 
merge into (select * from t2) t2 using t1 on(t2.f1 =  t1.f1)     when matched then update set t2.f2 = t2.f2 + 1;
merge into (select f1,f2 from t2) t22 using t1 on(t22.f1 =  t1.f1)     when matched then update set t22.f2 = t22.f2 + 1;
merge into t2 t22(f11, f22) using t1 on(t22.f11 =  t1.f1)     when matched then update set t22.f22 = t22.f22 + 1   delete where t22.f11 >= 2;
merge into (select * from t2) t2 using (select * from t1) t1 on(t2.f1 = 1)      when matched then update set t2.f2 = t2.f2 + 1     when not matched then insert(t2.f1,t2.f2) values (t1.f1, t1.f2);
merge into (select * from t2) t2 using (select * from t1) t1 on(t2.f1 = 1)      when matched then update set t2.f2 = t2.f2 + 1  delete where t2.f2 > 100   when not matched then insert(t2.f1,t2.f2) values (t1.f1, t1.f2);
merge into (select f1,f2 from t2) t22 using t1 on(t22.f1 =  t1.f1)     when matched then update set t22.f2 = t22.f2 + 1     when not matched then delete where t22.f1 > 3;
select * from t2;

drop table t1;
drop table t2;

