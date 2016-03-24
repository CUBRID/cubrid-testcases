select log10(cast(2 as short)) from db_root;
select log10(cast(2 as int)) from db_root;
select log10(cast(2 as bigint)) from db_root;
select log10(cast(2 as float)) from db_root;
select log10(cast(2 as double)) from db_root;
select log10(cast(2 as numeric)) from db_root;
select log10(cast(2 as monetary)) from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select log10(null_c) from db_root;
drop table tbl;
