--create range partition table with date data type,create table,select data from two tables, they are partition - non partition join

create table range_test(id int not null ,	
				test_time time,
				test_date date,
				test_timestamp timestamp,primary key(id,test_date))
		PARTITION BY RANGE (test_date) (
		PARTITION p0 VALUES LESS THAN ('2006-01-01')
	);
	insert into range_test values(1,'06:00:00','2005-01-01','2005-01-01 09:00:00');
	insert into range_test values(2,'07:00:00','2005-06-01','2005-06-01 09:00:00');
	insert into range_test values(3,'08:00:00','2005-12-01','2005-12-01 09:00:00');

create table range_test2(id int not null primary key,	
				test_time time,
				test_date date,
				test_timestamp timestamp);
	insert into range_test2 values(1,'06:00:00','2005-01-01','2005-01-01 09:00:00');
	insert into range_test2 values(2,'07:00:00','2005-06-01','2005-06-01 09:00:00');
	insert into range_test2 values(3,'08:00:00','2005-12-01','2005-12-01 09:00:00');

select * from range_test A, range_test2 B order by a.id;
select a.test_date, b.test_date from range_test A, range_test2 B where a.test_date = '2005-12-01' order by a.id;



drop table range_test;
drop table range_test2;
