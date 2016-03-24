---- ALTER TABLE ...  CHANGE COLUMN  , same type
-- constraints : old constraints are lost
-- ordering : no order defined
-- name : different name


---------------------- FOREIGN KEY
--- renaming a referenced foreign key
create table t1 (i1 integer primary key);
create table t2 (i2 integer , foreign key (i2) references t1(i1));
insert into t1 values (1),(2),(3);
insert into t2 values (1),(2);

select * from t1 order by 1;
select * from t2 order by 1;
-- should fail: 
alter table t1 change column i1 i_1 integer primary key;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t2;
drop table t1;

--- renaming a column which has a foreign key
create table t1 (i1 integer primary key);
create table t2 (i2 integer , foreign key (i2) references t1(i1));
insert into t1 values (1),(2),(3);
insert into t2 values (1),(2);

select * from t1 order by 1;
select * from t2 order by 1;
-- should fail: 
alter table t2 change column i2 i_2 integer;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t2;
drop table t1;
