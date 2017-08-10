-- [er]alter table which create using int,smallint,numeric,float,real,double,monetary,timestamp to add 1 range partition having maxvalue on numeric field

create table range_test(id int not null primary key,
			test_int int,
			test_smallint smallint,
			test_numeric numeric(38,10),
			test_float float,
			test_real real,
			test_double double,
			test_monetary monetary,
			test_datetime timestamp);
ALTER TABLE range_test
	PARTITION BY RANGE (test_numeric) (
	PARTITION p0 VALUES LESS THAN MAXVALUE
);



drop table range_test;
