--create range partition table with char data type,create other range partition table with char data type,select data from these two tables and order by keyword

create table range_test2(id int ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp,primary key(id,test_char))
	PARTITION BY RANGE (test_char) (
	    PARTITION p0 VALUES LESS THAN ('ddd')
	);

insert into range_test2 values(21,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2007-01-01 09:00:00');
insert into range_test2 values(22,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2007-01-01 09:00:00');
insert into range_test2 values(23,'ccc','ccc',B'11',B'1101',N'ccc',N'ccc','cccccccccc','2007-01-01 09:00:00');


create table range_test3(id int ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp,primary key(id,test_char))
	PARTITION BY RANGE (test_char) (
	    PARTITION p0 VALUES LESS THAN ('ddd')
	);

insert into range_test3 values(31,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2007-01-01 09:00:00');
insert into range_test3 values(32,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2007-01-01 09:00:00');
insert into range_test3 values(33,'ccc','ccc',B'11',B'1101',N'ccc',N'ccc','cccccccccc','2007-01-01 09:00:00');

select * from range_test2 A, range_test3 B order by a.id,2,3,4,5,6,7,8,9,10,11;


drop table range_test2;
drop table range_test3;
