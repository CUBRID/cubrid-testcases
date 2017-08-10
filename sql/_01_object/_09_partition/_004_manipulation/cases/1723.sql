--[er]create range partition table with nvarchar data type and one partition,then insert data to this table,the separator field value is equal with  separator value

create table range_test(id int not null ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp,
                                primary key (id, test_nvarchar))
	PARTITION BY RANGE (test_nvarchar) (
	    PARTITION p0 VALUES LESS THAN (N'ddd')
	);
	insert into range_test values(4,'ddd','ddd',B'100',B'1110',N'ddd',N'ddd','dddddddddd','2007-01-01 09:00:00');




drop table range_test;
