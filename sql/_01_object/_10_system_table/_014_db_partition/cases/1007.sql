--Creaet List(have no NULL value) partition  with time type and retrieve infomation from db_partition
create table list_test(id int not null,	
			test_time time,
			test_date date,
			test_timestamp timestamp,
                        primary key(id,test_time))
	PARTITION BY LIST (test_time) (
	PARTITION p0 VALUES IN ('06:00:00 AM','07:00:00 AM','09:00:00 AM')
);


select * from db_partition where class_name like 'list%';

drop table list_test;
