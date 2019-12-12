--create table with no partition,create range table with date data type,then insert range table with records of the first table

create table range_test2(id int not null primary key,	
				test_time time,
				test_date date,
				test_timestamp timestamp);
	insert into range_test2 values(11,'06:00:00','2005-01-01','2005-01-01 09:00:00');
	insert into range_test2 values(12,'07:00:00','2005-06-01','2005-06-01 09:00:00');
	insert into range_test2 values(13,'08:00:00','2005-12-01','2005-12-01 09:00:00');
	create table range_test(id int not null,	
				test_time time,
				test_date date,
				test_timestamp timestamp,primary key (id,test_date))
		PARTITION BY RANGE (test_date) (
		PARTITION p0 VALUES LESS THAN ('2006-01-01')
	);
	insert into range_test values(1,'06:00:00','2005-01-01','2005-01-01 09:00:00');
	insert into range_test values(2,'07:00:00','2005-06-01','2005-06-01 09:00:00');
	insert into range_test values(3,'08:00:00','2005-12-01','2005-12-01 09:00:00');
insert into range_test select * from range_test2;
select * from range_test order by 1;


drop table range_test;
drop table range_test2;
