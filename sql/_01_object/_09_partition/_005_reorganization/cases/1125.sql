-- alter table which create using int,time,date,timestamp to add 3 range partitions on timestamp field

create table range_test(id int not null ,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp,primary key(id,test_timestamp));
   ALTER TABLE range_test
	PARTITION BY RANGE (test_timestamp) (
	PARTITION p0 VALUES LESS THAN ('2006-02-01 09:00:00'),
	PARTITION p1 VALUES LESS THAN ('2006-03-01 09:00:00'),
	PARTITION p2 VALUES LESS THAN ('2006-04-01 09:00:00')
);
select * from db_class where class_name like 'range_test%' order by class_name;


drop table range_test;
