drop table if exists t1;
drop table if exists t2;
drop table if exists tbl1;
drop table if exists tbl2;

create table t1 (col1 varchar, col2 varchar(1073741823), col3 varchar(10));
create table tbl1 as select * from t1;
select attr_name, data_type, prec from db_attribute where attr_name like '%col%' and class_name='tbl1' order by 1;
show columns from tbl1;

create table t2 (col1 char, col2 char(268435455), col3 char(10));
create table tbl2 as select * from t2;
select attr_name, data_type, prec from db_attribute where attr_name like '%col%' and class_name='tbl2' order by 1;
show columns from tbl2;

drop table t1;
drop table t2;
drop table tbl1;
drop table tbl2;
