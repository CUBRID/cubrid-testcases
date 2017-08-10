--Create list(have no NULL value) partition with timestamp type from db_partition
create table list_test(id int not null,	
			test_time time,
			test_date date,
			test_timestamp timestamp,
                        primary key(id,test_timestamp))
	PARTITION BY LIST (test_timestamp) (
	PARTITION p0 VALUES IN ('2006-01-01 09:00:00','2006-02-01 09:00:00','2006-03-01 09:00:00')
);

select * from db_partition where class_name like 'list%';


drop table list_test;
