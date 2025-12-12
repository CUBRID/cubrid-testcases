-- create hash partition table on a time field with size 2 and query all partition about this table 

create table hash_test(id int,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp, primary key(id,test_time))
	PARTITION BY HASH(test_time)
        PARTITIONS 2;

select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where class_name like 'hash%';


drop table hash_test;