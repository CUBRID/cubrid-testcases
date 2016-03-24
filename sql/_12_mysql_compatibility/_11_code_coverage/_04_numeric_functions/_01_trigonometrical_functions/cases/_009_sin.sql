select sin(cast(1 as short)) from db_root;
select sin(cast(1 as int)) from db_root;
select sin(cast(1 as bigint)) from db_root;
select sin(cast(1 as float)) from db_root;
select sin(cast(1 as double)) from db_root;
select sin(cast(1 as numeric)) from db_root;
select sin(cast(1 as monetary)) from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select sin(null_c) from db_root;
drop table tbl;
