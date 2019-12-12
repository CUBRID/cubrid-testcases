-- create hash partition table  and query all partition about this table  

create table hash_test(id int not null ,
			  test_char char(50),
			  test_varchar varchar(2000),
			  test_bit bit(16),
			  test_varbit bit varying(20),
			  test_nchar nchar(50),
			  test_nvarchar nchar varying(2000),
			  test_string string,
			  test_datetime timestamp,
                           primary key(id,test_nvarchar))
	PARTITION BY HASH(test_nvarchar)
        PARTITIONS 2;

select * from db_class where class_name like 'hash%' order by 1,2;


drop table hash_test;
