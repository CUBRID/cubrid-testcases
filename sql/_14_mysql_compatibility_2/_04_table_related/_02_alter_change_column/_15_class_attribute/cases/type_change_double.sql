---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from double

-- to int
create table t1 class attribute (c_d double)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_d=0.391e-3;

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_i int;

select class t1.c_i, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to numeric
create table t1 class attribute (c_d double)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_d=0.391e-3;

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_n numeric(10,5);

select class t1.c_n, i from t1 order by 1,2;

show columns in t1;

drop table t1;




-- to datetime
-- unsupported 
create table t1 class attribute (c_d double)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_d=0.391e-3;

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_dt datetime;

select class t1.c_d, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- int to varchar
create table t1 class attribute (c_d double)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_d=0.391e-3;

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_s varchar(30);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- int to char, value too big
create table t1 class attribute (c_d double)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_d=0.391e-3;

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_s char(4);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;
