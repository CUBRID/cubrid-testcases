select substring(to_char(tan(cast(4 as short))),0,16) from db_root;   
select substring(to_char(tan(cast(4 as int))),0,16) from db_root;     
select substring(to_char(tan(cast(4 as bigint))),0,16) from db_root;  
select substring(to_char(tan(cast(4 as float))),0,16) from db_root;   
select substring(to_char(tan(cast(4 as double))),0,16) from db_root;  
select substring(to_char(tan(cast(4 as numeric))),0,16) from db_root; 
select substring(to_char(tan(cast(4 as monetary))),0,16) from db_root;


create table tbl(null_c int);
insert into tbl values (null);
select tan(null_c) from db_root;
drop table tbl;
