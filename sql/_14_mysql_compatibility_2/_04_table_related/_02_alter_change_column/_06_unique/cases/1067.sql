---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : constraints  : UNIQUE KEY on multiple columns 
-- ordering : no order defined
-- name : same or different
-- type : changed


--------------------- UNIQUE keys

------- type the same, name changed - only one unique on 2 columns
create table t1 (d1 double , i1 integer);
create unique index idx on t1 (i1, d1);
insert into t1 values (1.112,2),(1.123,4);

-- should fail
insert into t1 values (1.112,2);

select * from t1 order by 1,2;
show columns in t1;
-- should be OK
alter table t1 change i1 s1 varchar(11);

-- should fail
insert into t1 values (1.112,'2');
-- should be OK
insert into t1 values (1.115,'2');
insert into t1 values (1.112,'3');
select * from t1 order by 1,2;
show columns in t1;

drop table t1;


------- type the same, name changed ; 2 unique indexes
create table t1 (d1 double , i1 integer unique);
create unique index idx on t1 (i1, d1);
insert into t1 values (1.112,2),(1.123,4);

-- should fail
insert into t1 values (1.112,2);

select * from t1 order by 1,2;
show columns in t1;
-- should be OK
alter table t1 change i1 s1 varchar(11);

-- should fail
insert into t1 values (1.112,'2');
insert into t1 values (1.115,'2');
-- should be OK
insert into t1 values (1.112,'3');
select * from t1 order by 1,2;
show columns in t1;

drop table t1;


------- type unchanged , name same - mixed unique key
create table t1 (s char(5) , i1 integer);
create unique index idx on t1 (s, i1);
insert into t1 values ('112',2),('123',4);

-- should fail
insert into t1 values ('112',2);

select * from t1 order by 1,2;
show columns in t1;
-- should be OK
alter table t1 change s s char(11);

-- should fail
insert into t1 values ('112',2);
-- should be OK
insert into t1 values ('112',3);

insert into t1 values ('12345678901',3);
select * from t1 order by 1,2;
show columns in t1;

drop table t1;


------- type unchanged , name same - unique single column
create table t1 (s char(5) unique , i1 integer);
insert into t1 values ('112',2),('123',4);

-- should fail
insert into t1 values ('112',2);

select * from t1 order by 1,2;
show columns in t1;
-- should be OK
alter table t1 change s s char(11) unique;

-- should fail
insert into t1 values ('112',2);
-- should be OK
insert into t1 values ('114',3);

insert into t1 values ('12345678901',3);
select * from t1 order by 1,2;
show columns in t1;

drop table t1;

