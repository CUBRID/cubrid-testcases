--create range partition table with timestamp data type and no maxvalue


create table range_test(id int,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp, primary key(id,test_timestamp))
   	PARTITION BY RANGE (test_timestamp) (
	PARTITION p0 VALUES LESS THAN ('2006-02-01 09:00:00'),
	PARTITION p1 VALUES LESS THAN ('2006-03-01 09:00:00'),
	PARTITION p2 VALUES LESS THAN ('2006-04-01 09:00:00')
);

select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name like 'range_test%' order by 1;


drop table range_test;
