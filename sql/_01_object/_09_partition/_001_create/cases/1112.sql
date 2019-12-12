--[er]create range partition table with bit data type having boundary values and maxvalue

create table range_test(id int ,
			test_char char(50),
			test_varchar varchar(2000),
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50),
			test_nvarchar nchar varying(2000),
			test_string string,
			test_datetime timestamp, primary key(id,test_bit))
PARTITION BY RANGE (test_bit) (
    PARTITION p0 VALUES LESS THAN (B'1010'),
    PARTITION p1 VALUES LESS THAN (B'101010'),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);

drop class range_test;
