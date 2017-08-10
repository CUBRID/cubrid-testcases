--[er]many List(have no NULL value) partition creating test with some numeric type values.
create table list_test(id int,
			test_int int,
			test_smallint smallint,
			test_numeric numeric(38,10),
			test_float float,
			test_real real,
			test_double double,
			test_monetary monetary,
			test_datetime timestamp, primary key(id,test_numeric))
	PARTITION BY LIST (test_numeric) (
	PARTITION p0 VALUES IN (1.1234,3.257,5.456,7.975,9.4356),
	PARTITION p1 VALUES IN (2.3456,4.85934,6.72145,8.5673,10.23467),
	PARTITION p2 VALUES IN (11.43567,13.3457,15.23467,17.9876,19.0985)
);
drop table list_test;
