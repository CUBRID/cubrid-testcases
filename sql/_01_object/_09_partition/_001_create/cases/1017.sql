--List(have NULL value) partition creating test with string type and null value
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
    PARTITION p0 VALUES IN ('aaaaaaaaaa',NULL)
);

select * from db_class where class_name like 'list%' and class_name not like 'dml%' order by 1;


drop table list_test;
