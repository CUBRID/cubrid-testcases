-- [er]create hash partition table on a monetary field with size 2  

create table hash_test(id int,
			 test_int int,
			 test_smallint smallint,
			 test_numeric numeric(38,10),
			 test_float float,
			 test_real real,
			 test_double double,
			 test_monetary monetary,
			 test_datetime timestamp, primary key(id,test_monetary))
	PARTITION BY HASH(test_monetary)
        PARTITIONS 2;

drop class hash_test;
