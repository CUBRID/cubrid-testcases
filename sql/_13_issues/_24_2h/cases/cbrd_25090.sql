-- A core dump occurs when NA is specified in the select list in the create view statement

drop table if exists tbl;

create table tbl(id int, v int);

create view v1 as select NA x from tbl;

drop view v1;
drop table tbl;
