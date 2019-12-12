-- insert data  whith create hash partition table on a int field with size4 and query data from 1st partition and then dorp table

create table hash_test(id int,
			 test_int int,
			 test_smallint smallint,
			 test_numeric numeric(38,10),
			 test_float float,
			 test_real real,
			 test_double double,
			 test_monetary monetary,
			 test_datetime timestamp, primary key(id,test_int))
	PARTITION BY HASH(test_int)
        PARTITIONS 4;

insert into hash_test values(20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');
select * from hash_test__p__p0;



drop table hash_test;