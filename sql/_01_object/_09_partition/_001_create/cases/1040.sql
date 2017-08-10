--[er]many List(have no NULL value) partition creating test with some monetary type values.
create table list_test(id int,
			test_int int,
			test_smallint smallint,
			test_numeric numeric(38,10),
			test_float float,
			test_real real,
			test_double double,
			test_monetary monetary,
			test_datetime timestamp, primary key(id,test_monetary))
	PARTITION BY LIST (test_monetary) (
	PARTITION p0 VALUES IN (10,12,14,16),
	PARTITION p1 VALUES IN (20,22,24,26),
	PARTITION p2 VALUES IN (30,32,34,36)
);
drop table list_test;
