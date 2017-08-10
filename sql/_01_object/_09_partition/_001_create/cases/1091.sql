--create range partition table with int data type and partition values less than MAXVALUE

create table range_test(id int,
			test_int int,
			test_smallint smallint,
			test_numeric numeric(38,10),
			test_float float,
			test_real real,
			test_double double,
			test_monetary monetary,
			test_datetime timestamp, primary key(id,test_int))
	PARTITION BY RANGE (test_int) (
	PARTITION p0 VALUES LESS THAN MAXVALUE
);

select * from db_class where class_name like 'range_test%' order by 1;


drop table range_test;
