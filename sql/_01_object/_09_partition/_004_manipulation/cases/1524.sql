--create range partition table with date data type and one partition,then insert data to this table,the inserted separator field value contains null value


create table range_test(id int not null,	
				test_time time,
				test_date date,
				test_timestamp timestamp,
                                primary key (id, test_date))
		PARTITION BY RANGE (test_date) (
		PARTITION p0 VALUES LESS THAN ('2006-01-01')
	);
	insert into range_test values(1,'06:00:00','2005-01-01','2005-01-01 09:00:00');
	insert into range_test values(2,'07:00:00','2005-06-01','2005-06-01 09:00:00');
	insert into range_test values(3,'08:00:00',NULL,'2005-12-01 09:00:00');


select * from range_test;	
select * from range_test where test_date  is NULL order by 1;


drop table range_test;
