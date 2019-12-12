--+ holdcas on;
set names utf8;
create table range_test(id int not null primary key ,
				test_char CHAR(10) collate utf8_gen,,
				test_varchar VARCHAR(2000) collate utf8_gen,
				test_string STRING collate utf8_gen,
				test_datetime timestamp)
	PARTITION BY RANGE (test_string) (
	    PARTITION p0 VALUES LESS THAN ('你nǎ啊123')
	);
	insert into range_test values(1,'ē','nǎ','你nǎ啊123','2007-01-01 09:00:00');
	insert into range_test values(2,'123','结果','你nǎ啊1234','2007-01-01 09:00:00');
	insert into range_test values(3,'你好我好他好大家都好啊','你你你','你bunǎ啊1234','2007-01-01 09:00:00');
	insert into range_test values(9,NULL,NULL,NULL,'2007-01-01 09:00:00');

delete from range_test  where test_string   = '你nǎ啊123';
select * from range_test order by 1;


drop table range_test;
set names iso88591;
commit;
--+ holdcas off;