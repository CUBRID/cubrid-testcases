-- [er]alter table which create using int,smallint,numeric,float,real,double,monetary,timestamp to add 1 range partition having maxvalue on bit field

create table range_test(id int not null,
			  test_char char(50),
			  test_varchar varchar(2000),
			  test_bit bit(16),
			  test_varbit bit varying(20),
			  test_nchar nchar(50),
			  test_nvarchar nchar varying(2000),
			  test_string string,
			  test_datetime timestamp,
                          primary key(id,test_bit));
ALTER TABLE range_test
	PARTITION BY RANGE (test_bit) (
	PARTITION p0 VALUES LESS THAN MAXVALUE
);




drop table range_test;
