autocommit off;
create table test_last_day_table(
	d1 date,
	d2 date 
);
insert into test_last_day_table(d1) values(DATE '9/6/1976');
select d1, last_day(d1) from test_last_day_table;
select d2, last_day(d2) from test_last_day_table;
drop table test_last_day_table;
rollback;
