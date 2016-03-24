select log2(cast(9 as short)) from db_root;
select log2(cast(9 as int)) from db_root;
select log2(cast(9 as bigint)) from db_root;
select log2(cast(9 as float)) from db_root;
select log2(cast(9 as double)) from db_root;
select log2(cast(9 as numeric)) from db_root;
select log2(cast(9 as monetary)) from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select log2(null_c) from db_root;
drop table tbl;
