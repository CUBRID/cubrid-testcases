---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from int

-- to double 
create table t1 class attribute (c_ts timestamp)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_ts=timestamp'2001-05-07 10:11:12';

select class t1.c_ts, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_ts c_d double;

select class t1.c_ts, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to datetime
create table t1 class attribute (c_ts timestamp)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_ts=timestamp'2001-05-07 10:11:12';

select class t1.c_ts, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_ts c_dt datetime;

select class t1.c_dt, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to char, not enough chars
create table t1 class attribute (c_ts timestamp)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_ts=timestamp'2001-05-07 10:11:12';

select class t1.c_ts, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_ts c_c char(10);

select class t1.c_ts, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- to varnchar, enough chars
create table t1 class attribute (c_ts timestamp)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_ts=timestamp'2001-05-07 10:11:12';

select class t1.c_ts, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_ts c_s national char varying(26);

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;
