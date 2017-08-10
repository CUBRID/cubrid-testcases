-- [er]alter table which create using int,smallint,numeric,float,real,double,monetary,timestamp to add 1 range partition having maxvalue on float field

create table range_test(id int not null ,
			test_int int,
			test_smallint smallint,
			test_numeric numeric(38,10),
			test_float float,
			test_real real,
			test_double double,
			test_monetary monetary,
			test_datetime timestamp,primary key(id,test_float));
ALTER TABLE range_test
	PARTITION BY RANGE (test_float) (
	PARTITION p0 VALUES LESS THAN MAXVALUE
);



drop table range_test;
