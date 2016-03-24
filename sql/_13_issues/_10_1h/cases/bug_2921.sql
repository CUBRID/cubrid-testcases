create table tbl (
a int not null unique,
b int default 0,
c int);

insert into tbl values (0, 0, 0), (1, 1, 1);

select * from tbl order by a,b;

create table tbl2 as select a, b, c
from tbl;
select * from tbl2 order by a,b;

create table tbl3 as select a, b, c , 'string' as d
from tbl;
select * from tbl3 order by a,b;

drop table tbl;
drop table tbl2;
drop table tbl3;

create table ta as select cast(1 as short) as c1, 1 as c2, cast (1 as bigint) as c3, 1.0f as c4, cast(1 as double) as c5, 1.0 as c6, cast('abc' as char(3)) as c7, 'string' as c8, sysdate as c9, systime as c10, systimestamp as c11, sysdatetime as c12,N'123' as c13, B'1010' as c14, cast (1.0 as monetary) as c15;

select c1, c2, c3, c4, c5, c6, c7 from ta order by 1,2;
select attr_name, def_order, data_type,prec, scale from db_attribute where class_name = 'ta' order by def_order; 

drop table ta;