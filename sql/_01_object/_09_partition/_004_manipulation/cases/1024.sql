--[er]test insert(nvarchar varying) for list partition(have no NULL value) with null value
create table list_test(id int not null ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp,
                                primary key (id, test_nvarchar))
	PARTITION BY LIST (test_nvarchar) (
	    PARTITION p0 VALUES IN (N'aaa',N'bbb',N'ddd')
	);
insert into list_test values(5,NULL,'ccc',B'11',B'1101',N'ccc',N'ccc','cccccccccc','2007-01-01 09:00:00');
select * from list_test order by 1;


drop table list_test;
