--TEST: [Apricot BB] merge_insert_clause cannot not located before than merge_update_clause in MERGE statement (not compatible with oracle)


drop table if exists t1;
drop table if exists t2;

create table t1(a int, b varchar(10));
create table t2(a int, b varchar(10));

insert into t1 values(1, 'a');
insert into t1 values(2, 'b');

insert into t2 values(1, 'updated');
insert into t2 values(2, 'updated');
insert into t2 values(3, 'inserted');
insert into t2 values(4, 'inserted');


--TEST:
merge into t1 using t2 
on (t1.a=t2.a)
when not matched then
insert values(a, b)
where t2.a < 4
when matched then
update set t1.b=t2.b
where t2.a < 2;

select * from t1 order by 1, 2;

merge into t1 using t2 
on (t1.a=t2.a)
when not matched then
insert values(a, b)
where t2.a < 5
when matched then
update set t1.b=t2.b
where t1.a > 0
delete where t1.a=2;

select * from t1 order by 1, 2;


drop table t1, t2;
