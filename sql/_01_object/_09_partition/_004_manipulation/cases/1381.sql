--[er]test insert(smallint) for many list partition(have no NULL value) with null value.
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
insert into list_test values(10,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-01-01 09:00:00');
select * from list_test order by 1;


drop table list_test;
