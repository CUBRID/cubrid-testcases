---- ALTER TABLE ...  CHANGE COLUMN .., CHANGE COLUMN ..., MODIFY COLUMN ....
-- same attribute changed
-- This issue also verifies CBRD-24638.
-- Column default value problem when altering column type.
-- Altering default value column is allowed.


create table t1 class attribute (c_i int) (i1 integer, i2 integer, i3 integer);
update t1 set class t1.c_i=3;
insert into t1 values (1, 10, 100);

desc t1;
select i1,i2,i3, class t1.c_i from t1 order by 1,2,3,4;


alter table t1 change i1 f1 float not null default 4, modify f1 bigint;

insert into t1 values (2, 20, 200);

insert into t1 values (NULL, 30, 300);

insert into t1 set i3=400;

desc t1;
select f1,i2,i3, class t1.c_i from t1 order by 1,2,3,4;

drop table t1;


-- error case 1 : last change
create table t1 class attribute (c_i int) (i1 integer, i2 integer, i3 integer);
update t1 set class t1.c_i=3;
insert into t1 values (1, 10, 100);

desc t1;
select i1,i2,i3, class t1.c_i from t1 order by 1,2,3,4;

alter table t1 change i1 f1 float not null default 4, modify f1 date;

insert into t1 values (2, 20, 200);

insert into t1 values (NULL, 30, 300);

insert into t1 set i3=400;

desc t1;
select i1,i2,i3, class t1.c_i from t1 order by 1,2,3,4;

drop table t1;


-- error case 2 : first change
create table t1 class attribute (c_i int) (i1 integer, i2 integer, i3 integer);
update t1 set class t1.c_i=3;
insert into t1 values (1, 10, 100);
insert into t1 values (1, 10, 100);

desc t1;
select i1,i2,i3, class t1.c_i from t1 order by 1,2,3,4;

alter table t1 change i1 f1 float unique default 4, modify f1 float default -3;

insert into t1 values (2, 20, 200);

insert into t1 values (NULL, 30, 300);

insert into t1 set i3=400;

desc t1;
select i1,i2,i3, class t1.c_i from t1 order by 1,2,3,4;

drop table t1;

