--[er]test insert(smallint) for many list partition(have no NULL value) with incorrect values out of range
create table list_test(id int not null ,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp,
                                primary key (id, test_smallint))
		PARTITION BY LIST (test_smallint) (
		PARTITION p0 VALUES IN (1,3,5,7,9),
		PARTITION p1 VALUES IN (2,4,6,8,10),
		PARTITION p2 VALUES IN (11,13,15,17,19)
	);
insert into list_test values( 8,35,36,35.1802523285,35.9167372882,35.6244295835,35.982398624, 35,'2007-01-01 09:00:00');
select * from list_test order by 1;


drop table list_test;
