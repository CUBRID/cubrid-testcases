---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : DEFAULT
-- ordering : no order defined
-- name : same of different
-- type : same , prec increase 
-- other :


--  check update of 'DEFAULT' original value  
create table t1 ( i1 integer , s1 char varying(10) default 'xxxxx');
insert into t1 values (1,'123');
insert into t1 set i1 = 2;

-- should fail
insert into t1 values (10,'12345678901');
select * from t1 order by 1,2;
show columns in t1;

-- drop default
alter table t1 change s1 s1 char varying(15);

insert into t1 set i1 = 3;
insert into t1 values (4,'123456789012345');
show columns in t1;
select * from t1 order by 1,2;


-- change the precision again
alter table t1 change s1 s1 char varying(20);
insert into t1 set i1 = 5;
insert into t1 values (6,'12345678901234567890');

show columns in t1;
select * from t1 order by 1,2;

-- add the default again
alter table t1 change s1 s1 char varying(20) default 'x';
insert into t1 set i1 = 7;
insert into t1 values (8,'12345678901234567890');

show columns in t1;
select * from t1 order by 1,2;

drop table t1;








--  check update of 'DEFAULT' original value    - column is added with alter
create table t1 ( i1 integer );

insert into t1 set i1 = 0;

alter table t1 add column s1 char varying(10) default 'xxxxx';

insert into t1 values (1,'123');
insert into t1 set i1 = 2;
select * from t1 order by 1,2;
show columns in t1;

-- should fail
insert into t1 values (10,'12345678901');
select * from t1 order by 1,2;
show columns in t1;

-- drop default
alter table t1 change s1 s1 char varying(15);

insert into t1 set i1 = 3;
insert into t1 values (4,'123456789012345');
show columns in t1;
select * from t1 order by 1,2;


-- change the precision again
alter table t1 change s1 s1 char varying(20);
insert into t1 set i1 = 5;
insert into t1 values (6,'12345678901234567890');

show columns in t1;
select * from t1 order by 1,2;

-- add the default again
alter table t1 change s1 s1 char varying(20) default 'x';
insert into t1 set i1 = 7;
insert into t1 values (8,'12345678901234567890');

show columns in t1;
select * from t1 order by 1,2;

drop table t1;



