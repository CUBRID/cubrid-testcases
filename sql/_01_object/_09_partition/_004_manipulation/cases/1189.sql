--test delete(timestamp): deleting all data in a list partition(has NULL) using a delete statement with all of the partition key values
create table list_test(id int,	
				test_time time,
				test_date date,
				test_timestamp timestamp, primary key(id,test_timestamp))
		PARTITION BY LIST (test_timestamp) (
		PARTITION p0 VALUES IN ('2006-01-01 09:00:00',NULL,'2006-02-01 09:00:00','2006-03-01 09:00:00')
	);
	insert into list_test values(1,'06:00:00','2006-01-01','2006-01-01 09:00:00');
	insert into list_test values(2,'07:00:00','2006-02-01','2006-02-01 09:00:00');
	insert into list_test values(3,'09:00:00','2006-03-01','2006-03-01 09:00:00');
	insert into list_test values(4,'06:00:00','2006-01-01','2006-01-01 09:00:00');
	insert into list_test values(5,'07:00:00','2006-02-01','2006-02-01 09:00:00');
	insert into list_test values(6,'09:00:00','2006-03-01','2006-03-01 09:00:00');
	insert into list_test values(7,NULL,NULL,NULL);
delete from list_test where test_timestamp IN ('2006-01-01 09:00:00',NULL,'2006-02-01 09:00:00','2006-03-01 09:00:00');
select * from list_test order by id;


drop table list_test;
