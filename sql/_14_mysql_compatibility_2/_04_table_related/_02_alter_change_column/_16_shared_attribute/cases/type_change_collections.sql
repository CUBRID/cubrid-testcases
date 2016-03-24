---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from double


-- set to set 1
create table t1 (s1 set(int,varchar(10)) shared NULL, i2 int);

insert into t1 values ({'1'},1),({4,'2'},2);
update t1 set t1.s1={4.5,'123'};

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 set(int,float,varchar(10));

update t1 set t1.s1={4.5,'123'};

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- set to set 2
create table t1 (s1 set(int,varchar(10)) shared {}, i2 int);

insert into t1 values ({'1'},1),({4,'2'},2);
update t1 set t1.s1={4.5,'123'};

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 set(float,char(2));

update t1 set t1.s1={4.5,'12'};

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- set to seq
create table t1 (s1 set(int,varchar(10)) shared {}, i2 int);

insert into t1 values ({'1'},1),({4,'2'},2);
update t1 set t1.s1={4.5,'123'};

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change s1 s1 sequence(float,char(2));

update t1 set t1.s1={4.5,'123'};

select * from t1 order by 1,2;
show columns in t1;

drop table t1;