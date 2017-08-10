-- [er]create hash partition table on a timestamp field with size 0

create table hash_test(id int,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp, primary key(id,test_timestamp))
	PARTITION BY HASH(test_timestamp)
        PARTITIONS 0;

drop class hash_test;
