--List(have NULL value) partition creating test with timestamp type and null value
create table list_test(id int,	
			test_time time,
			test_date date,
			test_timestamp timestamp, primary key(id,test_timestamp))
	PARTITION BY LIST (test_timestamp) (
	PARTITION p0 VALUES IN ('2006-01-01 09:00:00','2006-02-01 09:00:00','2006-03-01 09:00:00',NULL)
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
