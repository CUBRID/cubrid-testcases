--create range partition table with smallint data type and no maxvalue


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
	PARTITION p0 VALUES LESS THAN (10),
	PARTITION p1 VALUES LESS THAN (20),
	PARTITION p2 VALUES LESS THAN (30)
);

select * from db_class where class_name like 'range_test%' order by 1;


drop table range_test;
