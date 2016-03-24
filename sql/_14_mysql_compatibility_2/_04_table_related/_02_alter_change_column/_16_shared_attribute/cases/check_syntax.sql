---- ALTER TABLE ...  CHANGE COLUMN  
-- ordering : change ordering
-- name : change or not

-- SHARED attribute
create class t1 class attribute( i1 integer ) ( i2 integer shared -1, i3 integer);
update t1 set class t1.i1=1;
update t1 set t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, t1.i2,i3 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 change class attribute i2 i_2 char(11);

-- should fail
alter table t1 change shared i2 class i_2 char(11);

alter table t1 change i2 c_2 char(11);

select class t1.i1, t1.c_2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


-- order
create class t1 class attribute( i1 integer) (i2 integer shared -1, i3 integer);
update t1 set class t1.i1=1;
update t1 set t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 change i2 c_2 char(11) after i3;

select class t1.i1, t1.c_2, i3 from t1 order by 3;
show columns in t1;

drop table t1;



-- MODIFY :
create class t1 class attribute( i1 integer) (i2 integer shared -1, i3 integer);
update t1 set class t1.i1=1;
update t1 set t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 modify class i2 integer shared -3;
select class t1.i1, t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 modify i2 integer after i1;
select class t1.i1, t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 modify i2 integer shared -10 after i3;
select class t1.i1, t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 modify i2 bigint first;
select class t1.i1, t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1; 



-- same name for SHARED and CLASS attribute
create class t1 class attribute( i1 integer) (i1 integer shared -1,i2 integer);
update t1 set class t1.i1=1;
update t1 set t1.i1=2;
insert into t1 set i2=10;
select class t1.i1, t1.i1,i2 from t1 order by 3;
show columns in t1;

alter table t1 change i1 i1 bigint;

show columns in t1;
select class t1.i1, t1.i1,i2 from t1 order by 3;

drop table t1;

 