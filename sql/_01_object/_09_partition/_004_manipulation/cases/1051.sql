--[er]test update(time) for list partition(have no NULL value) with null value.
create table list_test(id int not null ,	
				test_time time,
				test_date date,
				test_timestamp timestamp,
                                primary key (id, test_time))
		PARTITION BY LIST (test_time) (
		PARTITION p0 VALUES IN ('06:00:00','07:00:00','09:00:00')
	);
	insert into list_test values(1,'06:00:00','2006-01-01','2006-01-01 09:00:00');
	insert into list_test values(2,'07:00:00','2006-02-01','2006-02-01 09:00:00');
	insert into list_test values(3,'09:00:00','2006-03-01','2006-03-01 09:00:00');
	insert into list_test values(4,'06:00:00','2006-01-01','2006-01-01 09:00:00');
	insert into list_test values(5,'07:00:00','2006-02-01','2006-02-01 09:00:00');
	insert into list_test values(6,'09:00:00','2006-03-01','2006-03-01 09:00:00');
update list_test set test_time      = NULL where test_time      = '09:00:00';
select * from list_test order by id;


drop table list_test;
