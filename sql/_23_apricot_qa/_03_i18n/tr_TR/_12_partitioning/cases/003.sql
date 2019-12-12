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
			test_time time,
            primary key(id, test_time))
PARTITION BY LIST (test_time) (
    PARTITION p0 VALUES IN ('06:00:00 AM','07:00:00 AM','09:00:00 AM'),
	PARTITION p1 VALUES IN ('06:00:00 PM','07:00:00 PM','09:00:00 PM')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;

set names iso88591;
commit;
--+ holdcas off;

