---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from int

-- to short
create table t1 class attribute (c_d date)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_d=date'2001-05-07';

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_s short;

select class t1.c_d, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to datetime
create table t1 class attribute (c_d date)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_d=date'2001-05-07';

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_dt datetime;

select class t1.c_dt, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to varchar, not enough chars
create table t1 class attribute (c_d date)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_d=date'2001-05-07';

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_s varchar(4);

select class t1.c_d, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- to varchar, enough chars
create table t1 class attribute (c_d date)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_d=date'2001-05-07';

select class t1.c_d, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_d c_s varchar(12);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;
