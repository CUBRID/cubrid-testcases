--many List(have no NULL value) partition creating test with some date type values.
create table list_test(id int,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp, primary key(id,test_date))
   	PARTITION BY LIST (test_date) (
	PARTITION p0 VALUES IN ('2006-02-01','2006-02-11','2006-02-21'),
	PARTITION p1 VALUES IN ('2006-03-01','2006-03-11','2006-03-21'),
	PARTITION p2 VALUES IN ('2006-04-01','2006-04-11','2006-04-21')
);


select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
