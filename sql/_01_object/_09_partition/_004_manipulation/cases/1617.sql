--create range partition table with string data type and three partitions having no maxvalue,then insert data to this table,then delete record where the separated field value is null
create table range_test(id int not null ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp,
                                primary key (id, test_string))
	PARTITION BY RANGE (test_string) (
	    PARTITION p0 VALUES LESS THAN ('dddddddddd'),
    	    PARTITION p1 VALUES LESS THAN ('gggggggggg'),
    	    PARTITION p2 VALUES LESS THAN ('kkkkkkkkkk')
	);
	insert into range_test values(1,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2007-01-01 09:00:00');
	insert into range_test values(2,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2007-01-01 09:00:00');
	insert into range_test values(3,'ccc','ccc',B'11',B'1101',N'ccc',N'ccc','cccccccccc','2007-01-01 09:00:00');
	insert into range_test values(4,'ddd','ddd',B'100',B'1110',N'ddd',N'ddd','dddddddddd','2007-01-01 09:00:00');
	insert into range_test values(5,'eee','eee',B'101',B'1111',N'eee',N'eee','eeeeeeeeee','2007-01-01 09:00:00');
	insert into range_test values(6,'fff','fff',B'101',B'1111',N'fff',N'fff','ffffffffff','2007-01-01 09:00:00');
	insert into range_test values(7,'hhh','hhh',B'101',B'1111',N'hhh',N'hhh','hhhhhhhhhh','2007-01-01 09:00:00');
	insert into range_test values(8,'iii','iii',B'101',B'1111',N'iii',N'iii','iiiiiiiiii','2007-01-01 09:00:00');
	insert into range_test values(9,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-01-01 09:00:00');
delete from range_test  where test_string is NULL;
select * from range_test order by 1;


drop table range_test;
