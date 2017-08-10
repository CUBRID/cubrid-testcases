-- CREATE VIEW 

create table tab1 (i1 integer, i2 integer);

create view v1 as select i1 from tab1;

create or replace view v1 as select i2 from tab1;

drop view v1;
drop table tab1;
