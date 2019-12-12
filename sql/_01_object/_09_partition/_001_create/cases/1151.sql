-- [er]create hash partition table on a time field with size 0

create table hash_test(id int,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp, primary key(id,test_time))
	PARTITION BY HASH(test_time)
        PARTITIONS 0;

drop class hash_test;
