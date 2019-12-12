--[er]create range partition table with timestamp data type and one partition,then insert data to this table,the inserted separator field value is equal with boundary value

create table range_test(id int,	
				test_time time,
				test_date date,
				test_timestamp timestamp, primary key(id,test_timestamp))
		PARTITION BY RANGE (test_timestamp) (
		PARTITION p0 VALUES LESS THAN ('2006-01-01 09:00:00')
	);
	insert into range_test values(4,'09:00:00','2006-01-01','2006-01-01 09:00:00');




drop table range_test;
