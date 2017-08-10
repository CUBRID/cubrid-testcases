--+ holdcas on;
set names utf8;
create table list_test(id int,
			test_char char(50) collate utf8_tr_cs,
			test_varchar varchar(2000) collate utf8_tr_cs,
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50) collate utf8_tr_cs,
			test_nvarchar nchar varying(2000) collate utf8_tr_cs,
			test_string string,
			test_datetime timestamp,
            primary key(id, test_char))
PARTITION BY LIST (test_char) (
    PARTITION p0 VALUES IN ('Çç_Ğğ_İı','Öö_Şş_Üü'),
	PARTITION p1 VALUES IN ('啊阿','你好')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;


