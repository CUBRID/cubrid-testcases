--create range  table with smallint data type,create range table with smallint data type,then insert the second table with records of the first table and other data 

create table range_test2(id int,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp,primary key(id,test_smallint))
		PARTITION BY RANGE (test_smallint) (
		PARTITION p0 VALUES LESS THAN (10)
	);
	insert into range_test2 values( 21,1,2,1.952491373,1.040967569,1.8889608756,1.438915955,1,'2007-01-01 09:00:00');
	insert into range_test2 values( 22,2,3,2.102201596,2.448271838,2.309828743,2.862653912,2,'2007-01-01 09:00:00');
	insert into range_test2 values( 23,3,4,3.500607386,3.2760446668,3.861596361,3.511043858,3,'2007-01-01 09:00:00');
create table range_test(id int,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp,primary key(id,test_smallint))
		PARTITION BY RANGE (test_smallint) (
		PARTITION p0 VALUES LESS THAN (10)
	);
	insert into range_test values( 1,1,2,1.952491373,1.040967569,1.8889608756,1.438915955,1,'2007-01-01 09:00:00');
	insert into range_test values( 2,2,3,2.102201596,2.448271838,2.309828743,2.862653912,2,'2007-01-01 09:00:00');
	insert into range_test values( 3,3,4,3.500607386,3.2760446668,3.861596361,3.511043858,3,'2007-01-01 09:00:00');
insert into range_test select * from range_test2;
select * from range_test order by 1;


drop table range_test;
drop table range_test2;
