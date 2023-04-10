---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : DEFAULT
-- ordering : no order defined
-- name : same of different
-- type : type change 
-- other :



-- gaining 'DEFAULT' -- 2 column is added after table creation
create table t1 ( i1 integer );
insert into t1 values (0);
alter table t1 add column  d1 date;
insert into t1 values (1,date'2001-02-03');
insert into t1 set i1 = 2;

insert into t1 values (10, date'2002-04-05');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 char varying(30) default 'abc';

insert into t1 set i1 = 3;
insert into t1 values (4,'123456789012345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;


-- changing 'DEFAULT' -- column is added after table creation
create table t1 ( i1 integer );
insert into t1 values (0);
alter table t1 add column  d1 date default date'1999-06-06';
insert into t1 values (1,date'2001-02-03');
insert into t1 set i1 = 2;

insert into t1 values (10, date'2002-04-05');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 char varying(30) default 'abc';

insert into t1 set i1 = 3;
insert into t1 values (4,'123456789012345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;

-- This issue also verifies CBRD-24638.
-- Column default value problem when altering column type.
-- Altering default value column is allowed.
-- loosing 'DEFAULT' -- column is added after table creation
create table t1 ( i1 integer );
insert into t1 values (0);
alter table t1 add column  d1 date default date'1999-06-06';
insert into t1 values (1,date'2001-02-03');
insert into t1 set i1 = 2;


insert into t1 values (10, date'2002-04-05');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change d1 s1 char varying(30);

insert into t1 set i1 = 3;
insert into t1 values (4,'123456789012345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;
