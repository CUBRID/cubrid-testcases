autocommit off;
create table test_months_between(
	c1 date,
	i2 integer,
	c3 date,
	i4 integer,
	months_between_1_1 date,
	months_between_1_2 date
);
insert into test_months_between(c1,i2,months_between_1_1,months_between_1_2) values(date '1/31/1999',100,date '1/31/1999',date '1/01/1999');
		select months_between(date '1/2/1', date '2/1/1') from test_months_between;
		select months_between(date '1/2/1', date '2/2/1') from test_months_between;
		select months_between(date '3/30/1', date '4/30/1') from test_months_between;
		select months_between(date '1/31/1', date '2/28/1') from test_months_between;
		select months_between(date '3/31/1', date '4/30/1') from test_months_between;
		select months_between(date '1/2/1', date '1/2/1') from test_months_between;
		select months_between(date '2/1/1', date '1/2/1') from test_months_between;
		select months_between(date '2/2/1', date '1/2/1') from test_months_between;
		select months_between(date '4/30/1', date '3/30/1') from test_months_between;
		select months_between(date '2/28/1', date '1/31/1') from test_months_between;
		select months_between(date '4/30/1', date '3/31/1') from test_months_between;
create table test_months_between_table(
	d1 date,
	d2 date,
	d3 date 
);
insert into test_months_between_table (d1,d2) values(date '9/6/1976',date '2/6/1976');
		SELECT d1, date '2/6/1976', months_between(d1,date '2/6/1976') FROM test_months_between_table;
		SELECT date '9/6/1976',d2, months_between(date '9/6/1976',d2) FROM test_months_between_table;
		SELECT d1, d3, months_between(d1,d3) FROM test_months_between_table;
		SELECT d3, d2, months_between(d3,d2) FROM test_months_between_table;
		SELECT d3, d3, months_between(d3,d3) FROM test_months_between_table;
		SELECT c3, i2, months_between(c3,NULL) FROM test_months_between;
		SELECT c3, i2, months_between(NULL,c3) FROM test_months_between;
		SELECT c3, i4, months_between(NULL,NULL) FROM test_months_between;
drop table test_months_between;
rollback;
