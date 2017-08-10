CREATE TABLE tst_helper (i int);

insert into tst_helper values (11),(12),(13),(14);

CREATE TABLE tst (int_col int);

insert into tst(int_col) values (1);

select * from tst;

ALTER TABLE tst ADD COLUMN string_col string default current_user;

select int_col, if (string_col is not null, 'OK', 'NOK') from tst;

insert into tst(int_col) values (2);

insert into tst values (3, DEFAULT);

insert into tst(int_col) select i from tst_helper;

select if (lower(substring_index(string_col,'@',1)) = lower(substring_index(current_user,'@',1)), 'ok', 'nok') from tst where string_col is not null;

drop table tst_helper;

drop table tst;


