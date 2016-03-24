select degrees(cast(12 as short)) from db_root;
select degrees(cast(12 as int)) from db_root;
select degrees(cast(12 as bigint)) from db_root;
select degrees(cast(12 as float)) from db_root;
select degrees(cast(12 as double)) from db_root;
select degrees(cast(12 as numeric)) from db_root;
select degrees(cast(12 as monetary)) from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select degrees(null_c) from db_root;
drop table tbl;
