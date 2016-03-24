autocommit off;
create table test_last_day(
	c1 date,
	i2 integer,
	c3 date,
	i4 integer
);
insert into test_last_day(c1) values(date '9/6/1976');
	select last_day(date '1/01/1999') from test_last_day;
	select last_day(date '2/01/1999') from test_last_day;
	select last_day(date '3/01/1999') from test_last_day;
	select last_day(date '4/01/1999') from test_last_day;
	select last_day(date '5/01/1999') from test_last_day;
	select last_day(date '6/01/1999') from test_last_day;
	select last_day(date '7/01/1999') from test_last_day;
	select last_day(date '8/01/1999') from test_last_day;
	select last_day(date '9/01/1999') from test_last_day;
	select last_day(date '10/01/1999') from test_last_day;
	select last_day(date '11/01/1999') from test_last_day;
	select last_day(date '12/01/1999') from test_last_day;
		select last_day(date '1/01/2000') from test_last_day;
		select last_day(date '2/01/2000') from test_last_day;
		select last_day(date '3/01/2000') from test_last_day;
		select last_day(date '4/01/2000') from test_last_day;
		select last_day(date '5/01/2000') from test_last_day;
		select last_day(date '6/01/2000') from test_last_day;
		select last_day(date '7/01/2000') from test_last_day;
		select last_day(date '8/01/2000') from test_last_day;
		select last_day(date '9/01/2000') from test_last_day;
		select last_day(date '10/01/2000') from test_last_day;
		select last_day(date '11/01/2000') from test_last_day;
		select last_day(date '12/01/2000') from test_last_day;
		select last_day(date '2/1/1') from test_last_day;
		select last_day(date '2/1/4') from test_last_day;
		select last_day(date '2/1/100') from test_last_day;
		select last_day(date '2/1/400') from test_last_day;
		select last_day(date '2/1/1500') from test_last_day;
		select last_day(date '2/1/1600') from test_last_day;
		select last_day(date '2/1/1752') from test_last_day;
		select last_day(date '2/1/1800') from test_last_day;
		select last_day(date '2/1/1904') from test_last_day;
		select last_day(date '2/1/2000') from test_last_day;
	SELECT c1, last_day(c1) FROM test_last_day;
	SELECT c3, last_day(c3) FROM test_last_day;
	SELECT NULL, last_day(NULL) FROM test_last_day;
drop table test_last_day;
rollback;
