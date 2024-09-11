-- A core dump occurs when NA is specified in the select list in the create view statement

drop table if exists tbl;

create table tbl(id int, v int);

select NA x from tbl;

create view v1 as select NA x from tbl;
alter view v1 add query select null from tbl;

-- view create is query statement without from clause
alter view v1 add query select null;

-- scalar query
alter view v1 add query select (select null) from tbl;

alter view v1 add query select (select (select null) ) from tbl;
alter view v1 add query select (select (select (select null) ) ) from tbl;

alter view v1 add query select (select (select (select (select (select null) ) ) ) ) from tbl;

-- single quotation
alter view v1 add query select '' from tbl;

drop view v1;
drop table tbl;
