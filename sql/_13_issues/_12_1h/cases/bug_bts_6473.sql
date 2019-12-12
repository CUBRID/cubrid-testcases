--TEST: Update one table twice. The result is not same with MySQL


create table t (i int);
create table dummy (x int);
insert into t values (1), (2), (3);


-- server side execution, changing update order; results should differ
update t t1, t t2, t t3 set t1.i = 1, t2.i = 2, t3.i = 3;
select * from t order by 1 desc;
update t t2, t t3, t t1 set t1.i = 1, t2.i = 2, t3.i = 3;
select * from t order by 1;
update t t3, t t1, t t2 set t1.i = 1, t2.i = 2, t3.i = 3; 
select * from t order by 1;

-- server side execution, changing assignment order, results should be the same
update t t1, t t2, t t3 set t1.i = 1, t2.i = 2, t3.i = 3; 
select * from t order by 1 desc;
update t t1, t t2, t t3 set t2.i = 2, t3.i = 3, t1.i = 1; 
select * from t order by 1 desc;
update t t1, t t2, t t3 set t3.i = 3, t1.i = 1, t2.i = 2; 
select * from t order by 1 desc;

-- force broker side execution
create trigger trg after update on t execute insert into dummy values (123);

-- broker side execution, changing update order; results should differ
update t t1, t t2, t t3 set t1.i = 1, t2.i = 2, t3.i = 3; 
select * from t order by 1 desc;
update t t2, t t3, t t1 set t1.i = 1, t2.i = 2, t3.i = 3; 
select * from t order by 1;
update t t3, t t1, t t2 set t1.i = 1, t2.i = 2, t3.i = 3; 
select * from t order by 1;

-- broker side execution, changing assignment order, results should be the same
update t t1, t t2, t t3 set t1.i = 1, t2.i = 2, t3.i = 3; 
select * from t order by 1 desc;
update t t1, t t2, t t3 set t2.i = 2, t3.i = 3, t1.i = 1; 
select * from t order by 1 desc;
update t t1, t t2, t t3 set t3.i = 3, t1.i = 1, t2.i = 2; 
select * from t order by 1 desc;


drop trigger trg;
drop table t, dummy;
