---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints :  constraints  PRIMARY KEY is not maintained in new def
-- ordering : no order defined
-- name : same names
-- type : precision changed


------- type changed (precision), loose PRIMARY KEY 
create table t1 (s varchar(10) primary key);
insert into t1 values ('123'),('abc');

-- should fail
insert into t1 values ('123');
-- should fail
insert into t1 values ('123456789012345');

select * from t1  order by 1;
show columns in t1;
-- should be OK
alter table t1 change s s varchar(20);

-- should fail
insert into t1 values ('123');
-- should be OK:
insert into t1 values ('123456789012345');
select * from t1 order by 1;
show columns in t1;

drop table t1;


