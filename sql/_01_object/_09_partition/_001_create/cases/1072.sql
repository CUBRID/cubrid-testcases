--create range partition table with time data type

create table range_test(id int,	
			test_time time,
			test_date date,
			test_timestamp timestamp, primary key(id,test_time))
	PARTITION BY RANGE (test_time) (
	PARTITION p0 VALUES LESS THAN ('09:00:00 AM')
);

select * from db_class where class_name like 'range_test%' order by 1;


drop table range_test;
