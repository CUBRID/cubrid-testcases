CREATE TABLE tst_helper (i int);

insert into tst_helper values (11),(12),(13),(14);

CREATE TABLE tst (int_col int);

insert into tst(int_col) values (1);

select * from tst;

ALTER TABLE tst ADD COLUMN datetime_col datetime default sys_datetime;

select int_col, if (datetime_col is not null, 'OK', 'NOK') from tst;

insert into tst(int_col) values (2);

insert into tst values (3, DEFAULT);

insert into tst(int_col) select i from tst_helper;

select if (abs(datetime_col - SYS_DATETIME) <= 86400, 'ok', 'nok') from tst where int_col <> 1 and int_col <> 4;

drop table tst_helper;

drop table tst;


