--List(have no NULL value) partition creating test with time type
create table list_test(id int,	
			test_time time,
			test_date date,
			test_timestamp timestamp, primary key(id,test_time))
	PARTITION BY LIST (test_time) (
	PARTITION p0 VALUES IN ('06:00:00 AM','07:00:00 AM','09:00:00 AM')
);



select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
