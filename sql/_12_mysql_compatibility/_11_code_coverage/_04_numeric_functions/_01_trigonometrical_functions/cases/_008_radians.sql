select radians(cast(90 as short)) from db_root;
select radians(cast(90 as int)) from db_root;
select radians(cast(90 as bigint)) from db_root;
select radians(cast(90 as float)) from db_root;
select radians(cast(90 as double)) from db_root;
select radians(cast(90 as numeric)) from db_root;
select radians(cast(90 as monetary)) from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select radians(null_c) from db_root;
drop table tbl;
