---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from double

-- to int, char has only digits
create table t1 class attribute (c_c char(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='123';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_i int;

select class t1.c_c, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to int, char has only digits, exact size
create table t1 class attribute (c_c char(3))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='123';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_i int;

select class t1.c_i, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to int, char other chars
create table t1 class attribute (c_c char(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='1QA23';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_i int;

select class t1.c_c, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to time
create table t1 class attribute (c_c char(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='10:12:13';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_t time;

select class t1.c_t, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to time, exact size
create table t1 class attribute (c_c char(8))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='10:12:13';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_t time;

select class t1.c_t, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to char, size decrease
create table t1 class attribute (c_c char(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='12abc';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_s char(5);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to varchar, size decrease, not enough
create table t1 class attribute (c_c char(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='12abc';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_s varchar(4);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to varchar,  size increase
create table t1 class attribute (c_c char(10))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_c='12abc';

select class t1.c_c, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_c c_s varchar(14);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;
