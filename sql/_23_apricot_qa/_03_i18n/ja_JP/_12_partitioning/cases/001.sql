--+ holdcas on;
set names utf8;
create table list_test(id int,
			test_char char(50) collate utf8_ja_exp,
			test_varchar varchar(2000) collate utf8_ja_exp,
			test_bit bit(16),
			test_varbit bit varying(20) ,
			test_nchar nchar(50)collate utf8_ja_exp,
			test_nvarchar nchar varying(2000)collate utf8_ja_exp,
			test_string string collate utf8_ja_exp,
			test_datetime timestamp,
            primary key(id, test_char))
PARTITION BY LIST (test_char) (
    PARTITION p0 VALUES IN ('亜唖娃阿哀愛','ヵ かカ がガ き'),
	PARTITION p1 VALUES IN ('月曜日','西暦')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;

