--+ holdcas on;
set names utf8;
create table range_test(id int,
				test_char char(10),
				test_varchar varchar(2000) collate utf8_tr_cs,
				test_bit bit(16),
				test_varbit bit varying(20),
				test_nchar nchar(50) collate utf8_tr_cs,
				test_nvarchar nchar varying(2000) collate utf8_tr_cs,
				test_string string collate binary,
				test_datetime timestamp,
                primary key(id, test_char))
	PARTITION BY RANGE (test_char) (
	    PARTITION p0 VALUES LESS THAN (_iso88591'şşş')
	);
	insert into range_test values(1,_iso88591'şşş','şşş',B'1',B'1011',N'şşş',N'şşş','şşşşşşşşşş','2007-01-01 09:00:00');
	insert into range_test values(2,_iso88591'ĞĞĞ','ĞĞĞ',B'10',B'1100',N'ĞĞĞ',N'ĞĞĞ','ĞĞĞĞĞĞĞĞĞĞ','2007-01-01 09:00:00');
	insert into range_test values(3,_iso88591'ÜÜÜ','ÜÜÜ',B'11',B'1101',N'ÜÜÜ',N'ÜÜÜ','ÜÜÜÜÜÜÜÜÜÜ','2007-01-01 09:00:00');
	insert into range_test values(4,_iso88591'qqq','qqq',B'11',B'1101',N'qqq',N'qqq','qqqqqqqqqq','2007-01-01 09:00:00');
	insert into range_test values(5,_iso88591'你你你','你你你',B'11',B'1101',N'你你你',N'你你你','你你你你你你你你你你','2007-01-01 09:00:00');
	insert into range_test values(9,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-01-01 09:00:00');

delete from range_test  where test_string   = 'şşş';
select * from range_test order by 1;


drop table range_test;
set names iso88591;
commit;
--+ holdcas off;
