--TEST: [Merge Statement] 'System error (allocate new node)' and 'Resources exhausted in query generation.' error occur when using constant condition in merge_update_clause.



-- server side

create table t1(a int, b int);
insert into t1 values(1, 100);

create table t2(a int, b int);
insert into t2 values(1, 200);

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b;
select * from t1;

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b+1 where (1=1);
select * from t1;

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where t1.b=t2.b+1 delete where (1=1);
select * from t1;

insert into t1 values (1, 100);

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where t1.b=100 delete where t2.b=t1.b;
select * from t1;

insert into t1 values (1, 100);

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where (1=1) delete where t2.b=t1.b;
select * from t1;

insert into t1 values (1, 100);

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where (1=1) delete where (1=1);
select * from t1;

drop t1;
drop t2;

-- client side

create table t1(a int, b int);
insert into t1 values(1, 100);

create table t2(a int, b int);
insert into t2 values(1, 200);

create table trg (s string);
create trigger t1_upd before statement update on t1 execute insert into trg values ('update');
create trigger t1_del before statement delete on t1 execute insert into trg values ('delete');

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b;
select * from t1;

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b+1 where (1=1);
select * from t1;

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where t1.b=t2.b+1 delete where (1=1);
select * from t1;

insert into t1 values (1, 100);

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where t1.b=100 delete where t2.b=t1.b;
select * from t1;

insert into t1 values (1, 100);

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where (1=1) delete where t2.b=t1.b;
select * from t1;

insert into t1 values (1, 100);

merge into t1 using t2 on (1=1) when matched then update set t1.b=t2.b where (1=1) delete where (1=1);
select * from t1;

select * from trg order by 1;

drop t1;
drop t2;
drop trg;



