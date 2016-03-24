---- ALTER TABLE ...  CHANGE COLUMN  , type change : one class object to another class object
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or diff


create class c1 (i1 integer);
create class c2 under c1 (i2 integer);
create class c3 under c2 (i3 integer);
create class b(i integer);

insert into c1 values(1),(2),(0);
insert into c2 values(10,11),(20,22),(0,0);
insert into c3 values(100,111,110),(200,222,220),(0,0,0);



-------------- change type to inherited class

create table t1 (p1 c2);

insert into t1 select c2 from c2 where c2.i1<>0;
select t1.p1,t1.p1.i1,t1.p1.i2 from t1 order by t1.p1.i1,t1.p1.i2;
show columns in t1;

-- should fail
alter table t1 change p1 p1 c3;
select t1.p1,t1.p1.i1,t1.p1.i2 from t1 order by t1.p1.i1,t1.p1.i2;
-- should fail
select t1.p1,t1.p1.i1,t1.p1.i2,t1.p1.i3 from t1 order by t1.p1.i1,t1.p1.i2,t1.p1.i3;
show columns in t1;

drop table t1;


-------------- change type to super- class
create table t1 (p1 c2);

insert into t1 select c2 from c2 where c2.i1<>0;
select t1.p1,t1.p1.i1,t1.p1.i2 from t1 order by t1.p1.i1,t1.p1.i2;
show columns in t1;

-- should be OK
alter table t1 change p1 p1 c1;
-- should fail
select t1.p1,t1.p1.i1,t1.p1.i2 from t1 order by t1.p1.i1,t1.p1.i2;
select t1.p1,t1.p1.i1 from t1 order by t1.p1.i1;
show columns in t1;

drop table t1;

-------------- change type to class from other hierarchy
create table t1 (p1 c2);

insert into t1 select c2 from c2 where c2.i1<>0;
select t1.p1,t1.p1.i1,t1.p1.i2 from t1 order by t1.p1.i1,t1.p1.i2;
show columns in t1;

-- should fail
alter table t1 change p1 p1 b;
select t1.p1,t1.p1.i1,t1.p1.i2 from t1 order by t1.p1.i1,t1.p1.i2;
-- should fail
select t1.p1,t1.p1.i from t1 order by t1.p1.i;
show columns in t1;

drop table t1;



drop c3;
drop c2;
drop c1;
drop b;
