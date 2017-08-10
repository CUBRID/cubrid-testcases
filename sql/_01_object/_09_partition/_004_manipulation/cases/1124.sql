--[er]test insert(smallint) for list partition(have no NULL value) with null value.
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
		PARTITION p0 VALUES IN (1,3,5,7,9)
	);
insert into list_test values(5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2007-01-01 09:00:00');
select * from list_test order by 1;


drop table list_test;
