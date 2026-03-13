--Create List(have no NULL value) partition with date type and retrieve information from db_partition
create table list_test(id int not null,	
			test_time time,
			test_date date,
			test_timestamp timestamp,
                        primary key(id,test_date))
	PARTITION BY LIST (test_date) (
	PARTITION p0 VALUES IN ('2006-01-01','2006-02-01','2006-03-01')
);


select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition where class_name = 'list_test';

drop table list_test;
