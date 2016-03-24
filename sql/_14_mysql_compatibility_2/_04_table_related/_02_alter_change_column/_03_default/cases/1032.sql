---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : DEFAULT
-- ordering : no order defined
-- name : same of different
-- type : same , prec increase 
-- other :


-- gaining 'DEFAULT' -- 1 column is added at table creation
create table t1 ( i1 integer , s1 char varying(10));
insert into t1 values (1,'123');
insert into t1 set i1 = 2;

-- should fail
insert into t1 values (10,'12345678901');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 char varying(20) default 'abc';

insert into t1 set i1 = 3;
insert into t1 values (4,'12345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;


-- gaining 'DEFAULT' -- 2 column is added after table creation
create table t1 ( i1 integer );
insert into t1 values (0);
alter table t1 add column  s1 char varying(10);
insert into t1 values (1,'123');
insert into t1 set i1 = 2;

-- should fail
insert into t1 values (10,'12345678901');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 char varying(20) default 'abc';

insert into t1 set i1 = 3;
insert into t1 values (4,'12345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;



-- changing 'DEFAULT' -- 1 column is added at table creation ( original default value has diff precision than new value)
create table t1 ( i1 integer , s1 char varying(10) default 'xxxxxx');
insert into t1 values (1,'123');
insert into t1 set i1 = 2;

-- should fail
insert into t1 values (10,'12345678901');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 char varying(20) default 'abc';

insert into t1 set i1 = 3;
insert into t1 values (4,'12345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;


-- changing 'DEFAULT' -- 2 column is added after table creation ( original default value has diff precision than new value)
create table t1 ( i1 integer );
insert into t1 values (0);
alter table t1 add column s1 char varying(10) default 'xxxxxx';
insert into t1 values (1,'123');
insert into t1 set i1 = 2;

-- should fail
insert into t1 values (10,'12345678901');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 char varying(20) default 'abc';

insert into t1 set i1 = 3;
insert into t1 values (4,'12345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;


-- changing 'DEFAULT' -- 3 column is added after table creation (original default value has same precision with new value) 
create table t1 ( i1 integer );
insert into t1 values (0);
alter table t1 add column s1 char varying(10) default 'xxxxxx';
insert into t1 values (1,'123');
insert into t1 set i1 = 2;

-- should fail
insert into t1 values (10,'12345678901');
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 char varying(10) default 'abc';

insert into t1 set i1 = 3;
-- should fail
insert into t1 values (4,'12345678901234567890');
show columns in t1;


insert into t1 set i1 = 5;
select * from t1 order by 1,2;

drop table t1;


