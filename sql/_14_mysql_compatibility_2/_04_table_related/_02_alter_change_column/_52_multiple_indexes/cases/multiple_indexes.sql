---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : UNIQUE and/or NON-UNIQUE INDEX
-- ordering : no order defined
-- name : same name or different
-- contains indexes on other columns


-------------- compound index , type changes,
create table t1 (i1 integer unique primary key,i2 integer,i3 integer);

insert into t1 values (1,1,1),(2,2,2),(3,3,3);

alter table t1 add index idx1 (i1,i2);

alter table t1 add index idx2 (i1,i3);

show columns in t1;

select * from t1 order by 1,2,3;

alter table t1 change column i1 i1 char(11);

show columns in t1;

select * from t1 order by 1,2,3;


drop table t1;


-------------- compound index , type changes,
create table t1 (i1 integer unique primary key not null,i2 integer,i3 integer);

insert into t1 values (1,1,1),(2,2,2),(3,3,3);

alter table t1 add index idx1 (i1,i2);

alter table t1 add index idx2 (i1,i3);

show columns in t1;

select * from t1 order by 1,2,3;


alter table t1 change column i1 i1 char(11) not null;

show columns in t1;

select * from t1 order by 1,2,3;


drop table t1;



-------------- compound index , type changes, 
create table t1 (i1 integer unique primary key,s2 varchar(10),i3 integer);

insert into t1 values (1,'1',1),(2,'2',2),(3,'3',3);

alter table t1 add index idx1 (i1,s2);

alter table t1 add index idx2 (i1,i3);

alter table t1 add unique index idx3 (i1, s2, i3);

show columns in t1;

select * from t1 order by 1,2,3;


alter table t1 change column i1 i1 nchar varying(11) not null;

show columns in t1;

select * from t1 order by 1,2,3;


drop table t1;



-------------- compound index , type changes, 
create table t1 (i1 integer unique primary key,s2 varchar(10),i3 integer, d4 date);

insert into t1 values (1,'1',1,date'2010-10-01'),(2,'2',2,date'2010-10-02'),(3,'3',3,date'2010-10-03'),(4,'4',4,date'2010-10-04');

alter table t1 add index idx1 (i1,s2);

alter table t1 add index idx2 (i1,i3);

alter table t1 add unique index idx3 (i1, s2, i3);

alter table t1 add unique index idx4 (d4,i1);

show columns in t1;

select * from t1 order by 1,2,3;


alter table t1 change column i1 s1 nchar varying(11) not null;

-- should fail : unique (d4,i1)
insert into t1 values (n'4','2',1,date'2010-10-04');

-- should fail : unique (i1,s2,i3)
insert into t1 values (n'2','2',2,date'2010-10-04');

insert into t1 values (n'0','0',0,date'1999-10-04');

show columns in t1;

select * from t1 order by 1,2,3;


drop table t1;

