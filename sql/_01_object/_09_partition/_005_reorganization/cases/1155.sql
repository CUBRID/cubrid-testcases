-- alter table which create using int,char,varchar,bit,bit varying,nchar,nchar varying,string to add 1 range partition having maxvalue on nchar field

create table range_test(id int not null  ,
			  test_char char(50),
			  test_varchar varchar(2000),
			  test_bit bit(16),
			  test_varbit bit varying(20),
			  test_nchar nchar(50),
			  test_nvarchar nchar varying(2000),
			  test_string string,
			  test_datetime timestamp,primary key(id,test_nchar));
ALTER TABLE range_test
	PARTITION BY RANGE (test_nchar) (
	PARTITION p0 VALUES LESS THAN MAXVALUE
);
select * from db_class where class_name like 'range_test%' order by class_name;


drop table range_test;
