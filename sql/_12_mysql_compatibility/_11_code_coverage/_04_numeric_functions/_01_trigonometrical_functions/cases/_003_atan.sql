SELECT ATAN(0) from db_root;

SELECT ATAN(NULL) from db_root;

SELECT ATAN('a') from db_root;

SELECT ATAN('2') from db_root;

SELECT substring(to_char(ATAN(PI())),0,16) from db_root;

SELECT ATAN(2) from db_root;

select atan(cast(2 as short)) from db_root;
select atan(cast(2 as int)) from db_root;
select atan(cast(2 as bigint)) from db_root;
select atan(cast(2 as float)) from db_root;
select atan(cast(2 as double)) from db_root;
select atan(cast(2 as numeric)) from db_root;
select atan(cast(2 as monetary)) from db_root;

SELECT ATAN(NULL,NULL) from db_root;

select atan(1, cast(2 as short)) from db_root;
select atan(1, cast(2 as int)) from db_root;
select atan(1, cast(2 as bigint)) from db_root;
select atan(1, cast(2 as float)) from db_root;
select atan(1, cast(2 as double)) from db_root;
select atan(1, cast(2 as numeric)) from db_root;
select atan(1, cast(2 as monetary)) from db_root;


select atan(cast(1 as short), 2) from db_root;
select atan(cast(1 as int), 2) from db_root;
select atan(cast(1 as bigint), 2) from db_root;
select atan(cast(1 as float), 2) from db_root;
select atan(cast(1 as double), 2) from db_root;
select atan(cast(1 as numeric), 2) from db_root;
select atan(cast(1 as monetary), 2) from db_root;

create table tbl(null_c int);
insert into tbl values (null);
select atan(null_c) from db_root;
select atan(null_c, null_c) from db_root;
select atan(1, null_c) from db_root;
select atan(null_c, 1) from db_root;
drop table tbl;
