---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from double

-- to int, char has only digits
create table t1 class attribute (c_s varchar(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_s='123';

select class t1.c_s, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_s c_i int;

select class t1.c_i, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to int, char other chars
create table t1 class attribute (c_s varchar(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_s='1QA23';

select class t1.c_s, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_s c_i int;

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to date
create table t1 class attribute (c_s varchar(14))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_s='2001-04-07';

select class t1.c_s, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_s c_d date;

select class t1.c_d, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to char, size decrease
create table t1 class attribute (c_s varchar(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_s='12abcde';

select class t1.c_s, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_s c_c char(5);

select class t1.c_c, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to varchar, size decrease
create table t1 class attribute (c_s varchar(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_s='12abc';

select class t1.c_s, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_s c_s varchar(4);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to varchar,  size increase
create table t1 class attribute (c_s varchar(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_s='12abc';

select class t1.c_s, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_s c_s varchar(14);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;
