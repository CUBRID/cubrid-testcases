-- create range partition table on timestamp field having boundary values and add a partition and then query all partitions and drop table

create table range_test(id int not null ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp,primary key(id,test_datetime))
PARTITION BY RANGE (test_datetime) (
	PARTITION p0 VALUES LESS THAN ('2006-02-01 09:00:00'),
	PARTITION p1 VALUES LESS THAN ('2006-03-01 10:00:00'),
	PARTITION p2 VALUES LESS THAN ('2006-04-01 11:00:00')
);
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition order by 3,4;

ALTER TABLE range_test add partition (
partition p3 values less than ('2006-05-01 11:00:00')
);
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition order by 3,4;
select attr_name, class_name, default_value, is_partition_key from db_attribute where class_name = 'range_test' order by 1;

drop class range_test;
