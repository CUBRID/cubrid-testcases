-- alter table which create using int,time,date,timestamp to add 1 range partition on date field

create table range_test(id int not null ,	
			test_time time,
			test_date date,
			test_timestamp timestamp,primary key(id,test_date));
ALTER TABLE range_test
	PARTITION BY RANGE (test_date) (
	PARTITION p0 VALUES LESS THAN ('2006-01-01')
);
select * from db_class where class_name like 'range_test%' order by class_name;


drop table range_test;
