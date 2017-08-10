-- insert data  whith create hash partition table on a nchar field with size4 and query data from 1st partition and then dorp table

create table hash_test(id int not null ,
			  test_char char(50),
			  test_varchar varchar(2000),
			  test_bit bit(16),
			  test_varbit bit varying(20),
			  test_nchar nchar(50),
			  test_nvarchar nchar varying(2000),
			  test_string string,
			  test_datetime timestamp,
                          primary key (id, test_nchar))
	PARTITION BY HASH(test_nchar)
        PARTITIONS 4;
insert into hash_test values(20,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');
select * from hash_test__p__p0;



drop table hash_test;
