-- create hash partition table on a varchar field with size 2 and query all partition about this table  

create table hash_test(id int ,
			  test_char char(50),
			  test_varchar varchar(2000),
			  test_bit bit(16),
			  test_varbit bit varying(20),
			  test_nchar nchar(50),
			  test_nvarchar nchar varying(2000),
			  test_string string,
			  test_datetime timestamp, primary key(id,test_varchar))
	PARTITION BY HASH(test_varchar)
	PARTITIONS 2;


select * from db_class where class_name like 'hash%';


drop table hash_test;