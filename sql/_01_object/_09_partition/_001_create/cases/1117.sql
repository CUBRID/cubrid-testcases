--create range partition table with string data type having boundary values and maxvalue

create table range_test(id int ,
			test_char char(50),
			test_varchar varchar(2000),
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50),
			test_nvarchar nchar varying(2000),
			test_string string,
			test_datetime timestamp, primary key(id,test_string))
PARTITION BY RANGE (test_string) (
    PARTITION p0 VALUES LESS THAN ('dddddddddd'),
    PARTITION p1 VALUES LESS THAN ('gggggggggg'),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);


select * from db_class where class_name like 'range_test%' order by 1,2;


drop table range_test;
