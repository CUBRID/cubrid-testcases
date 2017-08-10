-- create hash partition table and query all partition about this table   

create table hash_test(id int not null,
			 test_int int,
			 test_smallint smallint,
			 test_numeric numeric(38,10),
			 test_float float,
			 test_real real,
			 test_double double,
			 test_monetary monetary,
			 test_datetime timestamp,
                         primary key(id,test_smallint) )
	PARTITION BY HASH(test_smallint)
        PARTITIONS 2;

select * from db_class where class_name like 'hash%'  order by 1;


drop table hash_test;
