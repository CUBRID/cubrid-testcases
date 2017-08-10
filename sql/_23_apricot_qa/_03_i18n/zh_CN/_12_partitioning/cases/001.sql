--+ holdcas on;
set names utf8;
create table list_test(id int not null primary key ,
			test_char CHAR(50) collate utf8_gen,
			test_varchar VARCHAR(2000) collate utf8_gen,
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nCHAR(50) collate utf8_gen,
			test_nvarchar nchar varying(2000) collate utf8_gen,,
			test_string STRING collate utf8_gen,
			test_datetime timestamp)
PARTITION BY LIST (test_char) (
    PARTITION p0 VALUES IN ('和谐号1','ĀǗ_五一_你好'),
	PARTITION p1 VALUES IN ('啊阿','你好')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;

