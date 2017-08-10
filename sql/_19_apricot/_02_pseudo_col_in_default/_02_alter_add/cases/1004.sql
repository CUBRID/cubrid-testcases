CREATE TABLE tst_helper (i int);

insert into tst_helper values (11),(12),(13),(14);

CREATE TABLE tst (int_col int);

insert into tst(int_col) values (1);

select * from tst;

ALTER TABLE tst ADD COLUMN date_col date default sys_date;

select int_col, if (date_col is not null, 'OK', 'NOK') from tst;

insert into tst(int_col) values (2);

insert into tst values (3, DEFAULT);

insert into tst(int_col) select i from tst_helper;

select if (abs(date_col - SYS_DATE) <= 1, 'ok', 'nok') from tst where int_col <> 1 and int_col <> 4;

drop table tst_helper;

drop table tst;


