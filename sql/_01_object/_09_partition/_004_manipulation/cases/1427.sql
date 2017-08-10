--create range partition table with date data type and one partitions having no maxvalue,then insert data to this table,,then update the separator field value to null value

create table range_test(id int not null ,	
				test_time time,
				test_date date,
				test_timestamp timestamp,
                                primary key (id, test_date))
		PARTITION BY RANGE (test_date) (
		PARTITION p0 VALUES LESS THAN ('2006-01-01')
	);
	insert into range_test values(1,'06:00:00','2005-01-01','2005-01-01 09:00:00');
	insert into range_test values(2,'07:00:00','2005-06-01','2005-06-01 09:00:00');
	insert into range_test values(3,'08:00:00','2005-12-01','2005-12-01 09:00:00');
update range_test set test_date      = NULL where test_date = '2005-12-01';
select * from range_test  order by 1;


drop table range_test;
