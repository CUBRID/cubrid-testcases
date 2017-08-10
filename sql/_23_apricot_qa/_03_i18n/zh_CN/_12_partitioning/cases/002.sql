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
			test_monetary MONETARY)
PARTITION BY LIST (test_monetary) (
    PARTITION p0 VALUES IN (1,2),
	PARTITION p1 VALUES IN (-1,-2)
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names iso88591;
commit;
--+ holdcas off;

