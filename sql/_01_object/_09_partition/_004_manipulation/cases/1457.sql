--[er]create range partition table with smallint data type and one partition,then insert data to this table,the inserted separator field value is equal with separator value

create table range_test(id int,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp, primary key(id,test_smallint))
		PARTITION BY RANGE (test_smallint) (
		PARTITION p0 VALUES LESS THAN (10)
	);
	insert into range_test values( 4,4,10,4.399696514,4.436700499,4.363333523,1.4,4,'2007-01-01 09:00:00');




drop table range_test;
