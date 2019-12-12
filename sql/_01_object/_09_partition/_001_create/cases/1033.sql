--[er]List(have no NULL value) partition creating test with bit varying type
create table list_test(id int ,
			test_char char(50),
			test_varchar varchar(2000),
			test_bit bit(16),
			test_varbit bit varying(20),
			test_nchar nchar(50),
			test_nvarchar nchar varying(2000),
			test_string string,
			test_datetime timestamp, primary key(id,test_varbit))
PARTITION BY LIST (test_varbit) (
    PARTITION p0 VALUES IN (B'1010')
);
drop table list_test;
