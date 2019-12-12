--create range partition table with char data type and three partitions,select data from two tables,they are same(partition table self-join)

create table range_test(id int not null  ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp,primary key(id,test_char))
	PARTITION BY RANGE (test_char) (
	PARTITION p0 VALUES LESS THAN ('ddd'),
	PARTITION p1 VALUES LESS THAN ('ggg'),
	PARTITION p2 VALUES LESS THAN ('kkk')
	);

	insert into range_test values(1,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2007-01-01 09:00:00');
	insert into range_test values(2,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2007-01-01 09:00:00');
	insert into range_test values(3,'ccc','ccc',B'11',B'1101',N'ccc',N'ccc','cccccccccc','2007-01-01 09:00:00');
	insert into range_test values(4,'ddd','ddd',B'100',B'1110',N'ddd',N'ddd','dddddddddd','2007-01-01 09:00:00');
	insert into range_test values(5,'eee','eee',B'101',B'1111',N'eee',N'eee','eeeeeeeeee','2007-01-01 09:00:00');
	insert into range_test values(6,'fff','fff',B'101',B'1111',N'fff',N'eee','ffffffffff','2007-01-01 09:00:00');
	insert into range_test values(7,'hhh','hhh',B'101',B'1111',N'hhh',N'eee','hhhhhhhhhh','2007-01-01 09:00:00');
	insert into range_test values(8,'iii','iii',B'101',B'1111',N'iii',N'eee','iiiiiiiiii','2007-01-01 09:00:00');

select * from range_test A, range_test B order by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18;
select a.test_char, b.test_char from range_test A, range_test B where a.test_char = 'aaa' order by a.id, b.test_char;



drop table range_test;
