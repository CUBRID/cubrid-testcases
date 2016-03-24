---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : constraints  : UNIQUE KEY on multiple columns 
-- ordering : no order defined
-- name : same or different
-- type : same or different


--------------------- UNIQUE keys

------- type the same, name changed
create table t1 (d1 double , i1 integer);
create unique index idx on t1 (i1, d1);
insert into t1 values (1.112,2),(1.123,4);

-- should fail
insert into t1 values (1.112,2);

select * from t1 order by 1,2;
show columns in t1;
-- should be OK
alter table t1 change d1 d_1 double;

-- should fail
insert into t1 values (1.112,2);
-- should be OK
insert into t1 values (1.112,3);
select * from t1 order by 1,2;
show columns in t1;

drop table t1;



------- type unchanged (prec increase), name same
create table t1 (s varchar(5) , i1 integer);
create unique index idx on t1 (s, i1);
insert into t1 values ('112',2),('123',4);

-- should fail
insert into t1 values ('112',2);

select * from t1 order by 1,2;
show columns in t1;
-- should be OK
alter table t1 change s s varchar(10);

-- should fail
insert into t1 values ('112',2);
-- should be OK
insert into t1 values ('112',3);

insert into t1 values ('1234567890',3);
select * from t1 order by 1,2;
show columns in t1;

drop table t1;


------- type changed , name same
create table t1 (s varchar(5) , i1 integer);
create unique index idx on t1 (s, i1);
insert into t1 values ('112',2),('123',4);

-- should fail
insert into t1 values ('112',2);

select * from t1 order by 1,2;
show columns in t1;
-- should be OK
alter table t1 change s s national char varying(10);

-- should fail
insert into t1 values ('112',2);
-- should be OK
insert into t1 values ('112',3);

insert into t1 values ('1234567890',3);
select * from t1 order by 1,2;
show columns in t1;

drop table t1;

