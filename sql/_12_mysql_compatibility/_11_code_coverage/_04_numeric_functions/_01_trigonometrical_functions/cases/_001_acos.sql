select acos(1.0001) from db_root;

select acos(cast(1 as short)) from db_root;
select acos(cast(1 as int)) from db_root;
select acos(cast(1 as bigint)) from db_root;

select to_char(acos(cast(0.5 as float)),'9.9999999EEEE') from db_root;
select to_char(acos(cast(0.5 as double)),'9.9999999EEEE') from db_root;
select acos(cast(1 as numeric)) from db_root;
select to_char(acos(cast(0.5 as monetary)),'9.9999999EEEE') from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select acos(null_c) from db_root;
drop table tbl;
