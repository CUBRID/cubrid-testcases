--[er]List(have NULL value) partition creating test with double type and null value
create table list_test(id int,
			test_int int,
			test_smallint smallint,
			test_numeric numeric(38,10),
			test_float float,
			test_real real,
			test_double double,
			test_monetary monetary,
			test_datetime timestamp, primary key(id,test_double))
	PARTITION BY LIST (test_double) (
	PARTITION p0 VALUES IN (1.12345,2.34567,3.14568,NULL)
);
drop table list_test;
