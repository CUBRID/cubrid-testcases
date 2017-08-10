--many List(have no NULL value) partition creating test with some string type values.
create table list_test(id int ,
			test_char char(50),
			test_varchar varchar(2000),
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50),
			test_nvarchar nchar varying(2000),
			test_string string,
			test_datetime timestamp, primary key(id,test_string))
PARTITION BY LIST (test_string) (
    PARTITION p0 VALUES IN ('aaaaaaaaaa','bbbbbbbbbb','dddddddddd'),
    PARTITION p1 VALUES IN ('ffffffffff','gggggggggg','hhhhhhhhhh'),
    PARTITION p2 VALUES IN ('kkkkkkkkkk','llllllllll','nnnnnnnnnn')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
