--create range partition table with timestamp data type and three partitions having no maxvalue,then insert data to this table,then update the separator field value to null value

create table range_test(id int,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp, primary key(id,test_timestamp))
		PARTITION BY RANGE (test_timestamp) (
		PARTITION p0 VALUES LESS THAN ('2006-02-01 09:00:00'),
		PARTITION p1 VALUES LESS THAN ('2006-03-01 09:00:00'),
		PARTITION p2 VALUES LESS THAN ('2006-04-01 09:00:00')
	);
	insert into range_test values(1,'08:10:00','2006-01-01','2006-01-01 08:10:00');
	insert into range_test values(2,'08:20:00','2006-01-11','2006-01-11 08:20:00');
	insert into range_test values(3,'09:10:00','2006-02-01','2006-02-01 09:10:00');
	insert into range_test values(4,'09:20:00','2006-02-11','2006-02-11 09:20:00');
	insert into range_test values(5,'09:30:00','2006-02-21','2006-02-21 09:30:00');
	insert into range_test values(6,'10:10:00','2006-03-01','2006-03-01 09:40:00');
	insert into range_test values(7,'10:20:00','2006-03-11','2006-03-11 09:50:00');
update range_test set test_timestamp      = NULL where test_timestamp      = '2006-02-21 09:30:00';
select * from range_test order by id;
select * from range_test__p__p0 order by id;
select * from range_test__p__p1 order by id;
select * from range_test__p__p2 order by id;


drop table range_test;
