--Alter table by adding some enum columns to a table that does not contain a enum column;
create table t1 (i int, j int);
alter table t1 add column e1 enum('a', 'b');
describe t1;

alter table t1 add column f float;
alter table t1 add column e2 enum('c', 'd');
describe t1;

drop table t1;