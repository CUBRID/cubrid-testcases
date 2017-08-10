-- [er]create hash partition table on a nchar field with size 0

create table hash_test(id int ,
			  test_char char(50),
			  test_varchar varchar(2000),
			  test_bit bit(16),
			  test_varbit bit varying(20),
			  test_nchar nchar(50),
			  test_nvarchar nchar varying(2000),
			  test_string string,
			  test_datetime timestamp, primary key(id,test_nchar))
	PARTITION BY HASH(test_nchar)
        PARTITIONS 0;

drop class hash_test;
