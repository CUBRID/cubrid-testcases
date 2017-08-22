--create range partition table with date data type,select data from two tables, they are the same table(self-join) 

create table range_test(id int,	
				test_time time,
				test_date date,
				test_timestamp timestamp,primary key(id,test_date))
		PARTITION BY RANGE (test_date) (
		PARTITION p0 VALUES LESS THAN ('2006-01-01')
	);
	insert into range_test values(1,'06:00:00','2005-01-01','2005-01-01 09:00:00');
	insert into range_test values(2,'07:00:00','2005-06-01','2005-06-01 09:00:00');
	insert into range_test values(3,'08:00:00','2005-12-01','2005-12-01 09:00:00');

select * from range_test A, range_test B order by 1,2,3,4,5,6;
select a.test_date, b.test_date from range_test A, range_test B where a.test_date = '2005-06-01' order by 1,2;


drop table range_test;
