--+ holdcas on;
set names utf8;
create table list_test(id int not null primary key ,
			test_char char(50)collate utf8_ja_exp,
			test_varchar varchar(2000)collate utf8_ja_exp,
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50)collate utf8_ja_exp,
			test_nvarchar nchar varying(2000)collate utf8_ja_exp,
			test_string string collate utf8_ja_exp,
			test_time time)
PARTITION BY LIST (test_time) (
    PARTITION p0 VALUES IN ('06:00:00 ÎçÇ°','07:00:00 ÎçÇ°','09:00:00 ÎçÇ°'),
	PARTITION p1 VALUES IN ('06:00:00 Îçáá','07:00:00 Îçáá','09:00:00 Îçáá')
);

select * from db_class where class_nÎçÇ°e like 'list%' order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;

