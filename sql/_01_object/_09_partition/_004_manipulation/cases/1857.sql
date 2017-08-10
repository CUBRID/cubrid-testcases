-- insert data  whith create hash partition table on a date field with size 4 and query data from 1st partition and then dorp table

create table hash_test(id int not null,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp,
                           primary key (id, test_date))
	PARTITION BY HASH(test_date)
        PARTITIONS 4;
insert into hash_test values(20,NULL,NULL,NULL);
select * from hash_test__p__p0;



drop table hash_test;
