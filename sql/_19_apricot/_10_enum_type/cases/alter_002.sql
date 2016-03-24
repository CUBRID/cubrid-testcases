--Alter table by adding some enum columns to a table that contains a enum column;
create table t1(e1 enum('a', 'b', 'c'));
describe t1;

alter table t1 add column e2 enum('1', '2', '3', '4', '5', '6', '7', '8', '9', '0');
describe t1;

drop table t1;