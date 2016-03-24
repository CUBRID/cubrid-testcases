---- ALTER TABLE ...  CHANGE COLUMN  
-- ordering : change ordering
-- name : change or not

-- change name + first
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 change class attribute i2 vc2 char(11) first;

select class t1.i1, class t1.vc2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


-- change name + after
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 change class attribute i1 b3 bigint after i2;

select class t1.b3, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;



-- same  name + first
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 change class attribute i2 i2 int first;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


-- same name + after
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

alter table t1 change class attribute i1 i1 int after i2;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


------ ERROR cases : 

-- change name + after  : name of normal attribute
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 change class attribute i1 i1 int after i3;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


-- change name + after  : name of shared attribute
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer, i4 integer shared -1);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3,i4 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 change class attribute i1 i1 int after i4;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


-- change name + after  : old name
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 change class attribute i1 i2_b integer after i1;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;


-- same name + after  : same attribute name
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

-- should fail
alter table t1 change class attribute i1 i1 integer after i1;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1;



-- MODIFY : same name + after  : same attribute name
create class t1 class attribute( i1 integer, i2 integer ) (i3 integer);
update t1 set class t1.i1=1;
update t1 set class t1.i2=2;
insert into t1 set i3=10;
select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;


-- should fail
alter table t1 modify class attribute i1 integer after i1;

select class t1.i1, class t1.i2,i3 from t1 order by 3;
show columns in t1;

drop table t1; 


 