--create range partition table with varchar data type and one partition having no maxvalue,then insert data to this table,then delete several records whose separated value less than partition boundary value

create table range_test(id int not null ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp,
                                primary key (id, test_varchar))
	PARTITION BY RANGE (test_varchar) (
	    PARTITION p0 VALUES LESS THAN ('ddd')
	);

	insert into range_test values(1,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2007-01-01 09:00:00');
	insert into range_test values(2,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2007-01-01 09:00:00');
	insert into range_test values(3,'ccc','ccc',B'11',B'1101',N'ccc',N'ccc','cccccccccc','2007-01-01 09:00:00');
	insert into range_test values(9,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-01-01 09:00:00');
delete from range_test where test_varchar     < 'ddd' ;
select * from range_test order by 1;


drop table range_test;
