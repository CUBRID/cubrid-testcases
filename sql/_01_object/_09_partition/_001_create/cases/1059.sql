--many List(have NULL value) partition creating test with some time type values and null value.
create table list_test(id int,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp, primary key(id,test_time))
   	PARTITION BY LIST (test_time) (
	PARTITION p0 VALUES IN ('09:00:00','09:10:00','09:20:00'),
	PARTITION p1 VALUES IN ('10:00:00','10:10:00','10:20:00',NULL),
	PARTITION p2 VALUES IN ('11:00:00','11:10:00','11:20:00')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
