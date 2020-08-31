--+ holdcas on;
set names utf8;
drop table if exists range_test;
create table range_test(id int,
				test_char char(10) collate utf8_ja_exp,
				test_varchar varchar(2000) collate utf8_ja_exp,
				test_string string collate utf8_ja_exp,
				test_datetime timestamp,
                primary key(id, test_string))
	PARTITION BY RANGE (test_string) (
	    PARTITION p0 VALUES LESS THAN ('ぁあぃい123')
	);
	insert into range_test values(1,'ē','shǎ','ぁあぃい123','2007-01-01 09:00:00');
	insert into range_test values(2,'123','和谐','ぁあぃい1234','2007-01-01 09:00:00');
	insert into range_test values(3,'日曜日火曜日紀元前西','チチチ','チもモ唖1234','2007-01-01 09:00:00');
	insert into range_test values(9,NULL,NULL,NULL,'2007-01-01 09:00:00');

delete from range_test  where test_string   = 'ぁあぃい123';
select * from range_test order by 1;


drop table range_test;
set names iso88591;
commit;
--+ holdcas off;
