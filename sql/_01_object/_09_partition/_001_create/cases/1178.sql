-- [er]create hash partition table on a bit varying field with size 0

create table hash_test(id int ,
			  test_char char(50),
			  test_varchar varchar(2000),
			  test_bit bit(16),
			  test_varbit bit varying(20),
			  test_nchar nchar(50),
			  test_nvarchar nchar varying(2000),
			  test_string string,
			  test_datetime timestamp, primary key(id,test_varbit))
	PARTITION BY HASH(test_varbit)
	PARTITIONS 0;

drop class hash_test;
