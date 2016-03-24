---- ALTER TABLE ...  CHANGE COLUMN  , type change or the same
-- constraints : AUTO INCREMENT
-- ordering : no order defined
-- name : same name or different


-------------- LOOSE auto_increment , type unchanged, same name
create table t1 (i1 integer auto_increment ,i2 integer);

insert into t1 values (7,1),(2,2);
insert into t1 set i2=3;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change column i1 i1 integer;

insert into t1 set i2=5;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-------------- GAIN auto_increment , type unchanged, same name
create table t1 (i1 integer,i2 integer);

insert into t1 values (7,1),(2,2);
insert into t1 set i2=3;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change column i1 i1 integer auto_increment;

insert into t1 set i2=5;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;

-------------- CHANGE auto_increment details - 1  , type unchanged, same name  
create table t1 (i1 integer auto_increment,i2 integer);

insert into t1 values (7,1),(2,2);
insert into t1 set i2=3;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change column i1 i1 integer auto_increment (10,2);

insert into t1 set i2=5;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;

-------------- CHANGE auto_increment details - 2  , type unchanged, same name  
create table t1 (i1 integer auto_increment(1,10),i2 integer);

insert into t1 values (7,1),(2,2);
insert into t1 set i2=3;
insert into t1 set i2=4;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change column i1 i1 integer auto_increment (1,2);

insert into t1 set i2=5;
insert into t1 set i2=6;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;




-------------- CHANGE auto_increment details   , type unchanged, CHANGE name  
create table t1 (i1 integer auto_increment(1,10),i2 integer);

insert into t1 values (7,1),(2,2);
insert into t1 set i2=3;
insert into t1 set i2=4;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change column i1 i_1 integer auto_increment (1,2);

insert into t1 set i2=5;
insert into t1 set i2=6;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;




