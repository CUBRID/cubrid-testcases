--create range partition table with int data type,create table,select data from two tables, they are partition - non partition join

create table range_test(id int not null ,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp,primary key(id,test_int))
		PARTITION BY RANGE (test_int) (
		PARTITION p0 VALUES LESS THAN (10)
	);
	insert into range_test values( 1,1,2,1.952491373,1.040967569,1.8889608756,1.438915955,1,'2007-01-01 09:00:00');
	insert into range_test values( 2,2,3,2.102201596,2.448271838,2.309828743,2.862653912,2,'2007-01-01 09:00:00');
	insert into range_test values( 3,3,4,3.500607386,3.2760446668,3.861596361,3.511043858,3,'2007-01-01 09:00:00');

create table range_test2(id int not null primary key,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp);
			insert into range_test2 values( 1,1,2,1.952491373,1.040967569,1.8889608756,1.438915955,1,'2007-01-01 09:00:00');
	insert into range_test2 values( 2,2,3,2.102201596,2.448271838,2.309828743,2.862653912,2,'2007-01-01 09:00:00');
	insert into range_test2 values( 3,3,4,3.500607386,3.2760446668,3.861596361,3.511043858,3,'2007-01-01 09:00:00');

select * from range_test A, range_test2 B order by a.id, b.id;
select * from range_test2 A, range_test B order by a.id, b.id;
select a.test_int, b.test_int from range_test A, range_test2 B where a.test_int =1.0 order by 1,2;
select a.test_int, b.test_int from range_test2 A, range_test B where a.test_int =1.0 order by 1,2;


drop table range_test;
drop table range_test2;
