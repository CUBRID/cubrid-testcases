--+ holdcas on;
--cases from dev


-- changing the name and position of a column

create table t1(i1 int,i2 int);
insert into t1 value (1,11),(2,22),(3,33);
select * from t1 order by 1;
alter table t1 change i2 i0 integer first;
select * from t1 order by 1;

drop table t1;



-- change the column's data type (no errors)

create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

alter table t1 change i1 s1 char(11);

select * from t1 order by 1;

drop table t1;



-- change the column's data type (errors), strict mode

set system parameters 'alter_table_change_type_strict=yes';

create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

alter table t1 change i1 s1 char(4);
select * from t1 order by 1;

drop table t1;



-- change the column's data type (errors)

set system parameters 'alter_table_change_type_strict=no';

create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

alter table t1 change i1 s1 char(4);

select length(s1) from t1;

drop table t1;
commit;
--+ holdcas off;
