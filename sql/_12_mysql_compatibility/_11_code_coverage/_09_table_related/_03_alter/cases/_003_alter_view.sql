-- ALTER VIEW .. AS ..

create table tab1 (i1 integer, i2 integer);

create view v1  as select i1 from tab1;

alter view v1   as select i2 from tab1;

-- should fail
create view v1 replace as select i1 from tab1;

drop view v1;
drop table tab1;

-- ALTER .. ADD/DROP QUERY
create table tab1 (i1 integer, i2 integer);
create view v1 as select i1 from tab1;

alter view v1 add query select i2+1 from tab1 where i2<1;

alter view v1 drop query;

drop view v1;
drop table tab1;

