---- ALTER TABLE ...  CHANGE COLUMN  
-- ordering : change ordering
-- name : change or not

-- CLASS attribute
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 change class i2 i_2 char(11);

-- should fail
alter table t1 change class i2 class i_2 char(11);

-- should fail
alter table t1 change class attribute i2 class attribute i_2 char(11);

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


-- order
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 change class attribute i2 i_2 char(11) after class attribute i1;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;



-- MODIFY :
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 modify class i1 integer;

-- should fail
alter table t1 modify class attribute i1 integer after class attribute i2;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1; 



-- same name for NORMAL and CLASS attribute
create class t1 class attribute( i integer ) (i integer);
update t1 set class t1.i=1;
insert into t1 set i=10;
select class t1.i, i from t1 order by 2;
show columns in t1;

alter table t1 change i i bigint;

show columns in t1;
select class t1.i, i from t1 order by 2;


alter table t1 change class attribute i i short;

show columns in t1;
select class t1.i, i from t1 order by 2;

drop table t1;

 