--test update(nchar) for list partition(have no NULL value) with correct values within range
create table list_test(id int ,
				test_char char(50),
				test_varchar varchar(2000),
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50),
				test_nvarchar nchar varying(2000),
				test_string string,
				test_datetime timestamp, primary key(id,test_nchar))
	PARTITION BY LIST (test_nchar) (
	    PARTITION p0 VALUES IN (N'aaa',N'bbb',N'ddd')
	);
	insert into list_test values(1,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2006-03-01 09:00:00');
	insert into list_test values(2,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2006-03-01 09:00:00');
	insert into list_test values(3,'ddd','ddd',B'100',B'1110',N'ddd',N'ddd','dddddddddd','2006-03-01 09:00:00');
	insert into list_test values(4,'aaa','aaa',B'100',B'1110',N'aaa',N'aaa','aaaaaaaaaa','2006-03-01 09:00:00');
	insert into list_test values(5,'bbb','bbb',B'100',B'1110',N'bbb',N'bbb','bbbbbbbbbb','2006-03-01 09:00:00');
	insert into list_test values(6,'ddd','ddd',B'100',B'1110',N'ddd',N'ddd','dddddddddd','2006-03-01 09:00:00');
update list_test set test_nchar     = N'bbb' where test_nchar     =N'aaa';
select * from list_test order by 1;


drop table list_test;
