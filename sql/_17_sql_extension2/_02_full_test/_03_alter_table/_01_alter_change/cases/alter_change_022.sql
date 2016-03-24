--exceptional cases


create table coo(a int, b varchar, c blob);

alter table coo change a a float;

--change multiple columns in one statement.
alter table coo change a aa float, change c cc blob;

--change a column name to an already existed one.
alter table coo change aa b float;

drop table coo;
