--test insert(time) for list partition(have no NULL value) with correct values within range
create table list_test(id int,	
				test_time time,
				test_date date,
				test_timestamp timestamp, primary key(id,test_time))
		PARTITION BY LIST (test_time) (
		PARTITION p0 VALUES IN ('06:00:00 AM','07:00:00 AM','09:00:00 AM')
	);
insert into list_test values(1,'06:00:00','2006-01-01','2006-01-01 09:00:00');
insert into list_test values(2,'07:00:00','2006-01-11','2006-02-01 09:00:00');
insert into list_test values(3,'09:00:00','2006-02-01','2006-03-01 09:00:00');
select * from list_test order by 1;


drop table list_test;
