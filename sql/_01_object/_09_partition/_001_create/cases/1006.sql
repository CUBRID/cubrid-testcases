--[er]List(have no NULL value) partition creating test with monetary type
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
	PARTITION p0 VALUES IN (10,20,30)
);
drop table list_test;
