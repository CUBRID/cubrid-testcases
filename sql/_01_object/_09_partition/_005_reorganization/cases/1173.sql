-- alter table which create using int,smallint,numeric,float,real,double,monetary,timestamp to add 1 range partition having maxvalue on int field

create table range_test(id int not null,
			test_int int,
			test_smallint smallint,
			test_numeric numeric(38,10),
			test_float float,
			test_real real,
			test_double double,
			test_monetary monetary,
			test_datetime timestamp,
                        primary key(id,test_int));
ALTER TABLE range_test
	PARTITION BY RANGE (test_int) (
	PARTITION p0 VALUES LESS THAN MAXVALUE
);
select * from db_class where class_name like 'range_test%' order by class_name;


drop table range_test;
