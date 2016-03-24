---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : DEFAULT
-- ordering : no order defined
-- name : same of different
-- type : change
-- other :



--  check update of 'DEFAULT' original value    - column is added with alter
create table t1 ( i1 integer );

insert into t1 set i1 = 0;

alter table t1 add column d1 date default date'1999-09-09';

insert into t1 values (1,date'2001-01-01');
insert into t1 set i1 = 2;
select * from t1 order by 1,2;
show columns in t1;

-- change to datetime, drop default
alter table t1 change d1 dt1 datetime;

insert into t1 set i1 = 3;
insert into t1 values (4,datetime'2004-04-04 04:04:04');
show columns in t1;
select * from t1 order by 1,2;


-- add the default again
alter table t1 change dt1 dt1 datetime default datetime'1999-09-09 09:09:09';
insert into t1 set i1 = 7;
insert into t1 values (8,datetime'1888-08-08 08:08:08');

show columns in t1;
select * from t1 order by 1,2;

drop table t1;



