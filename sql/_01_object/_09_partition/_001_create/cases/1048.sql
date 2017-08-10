--many List(have NULL value) partition creating test with some nchar type values and null value.
create table list_test(id int ,
			test_char char(50),
			test_varchar varchar(2000),
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50),
			test_nvarchar nchar varying(2000),
			test_string string,
			test_datetime timestamp, primary key(id,test_nchar))
PARTITION BY LIST (test_nchar) (
    PARTITION p0 VALUES IN (N'aaa',N'bbb',N'ddd'),
    PARTITION p1 VALUES IN (N'fff',N'ggg',N'hhh',NULL),
    PARTITION p2 VALUES IN (N'kkk',N'lll',N'mmm')
);

select * from db_class where class_name like 'list%' order by 1;


drop table list_test;
