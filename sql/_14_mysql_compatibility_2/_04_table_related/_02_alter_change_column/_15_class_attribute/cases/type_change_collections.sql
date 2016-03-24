---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from double


-- set to set 1
create table t1 class attribute (c_set set(int,varchar(10)))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_set={4,'123'};

select class t1.c_set, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_set c_set set(varchar(10),int,float);

select class t1.c_set, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- set to set 2
create table t1 class attribute (c_set set(int,varchar(10)))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_set={4,'123'};

select class t1.c_set, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_set c_set set(char(20),float);

select class t1.c_set, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- set to seq
create table t1 class attribute (c_set set(int,varchar(10)))  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_set={4,'123'};

select class t1.c_set, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_set c_seq sequence(char(20),float);

select class t1.c_seq, i from t1 order by 1,2;

show columns in t1;

drop table t1;