--+ holdcas on;
set names utf8;
create table list_test(id int,
			test_char char(50),
			test_varchar varchar(2000),
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50),
			test_nvarchar nchar varying(2000),
			test_string string,
			test_datetime timestamp,
            primary key(id, test_char))

PARTITION BY LIST (test_char) (
    PARTITION p0 VALUES IN (_utf8'កខណតស',_utf8'ហឡកឯ'),
	PARTITION p1 VALUES IN (_utf8'ហឡ៏ខ',_utf8'ឯឡ៏ខ')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
set names utf8;
commit;
--+ holdcas off;


