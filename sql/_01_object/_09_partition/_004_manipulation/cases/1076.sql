--test update(int) for list partition(have NULL value) with null value.
create table list_test(id int not null ,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp,
                                primary key (id, test_int))
		PARTITION BY LIST (test_int) (
		PARTITION p0 VALUES IN (1,3,NULL,5,7,9)
	);
	insert into list_test values( 1,1,1, 1.12345, 1.23456, 1.34567, 1.45678, 10,'2006-03-01 09:00:00');
	insert into list_test values( 2,3,3, 3.12345, 3.23456, 3.34567, 3.45678, 30,'2006-03-01 09:00:00');
	insert into list_test values( 3,5,5, 5.12345, 5.23456, 5.34567, 5.45678, 50,'2006-03-01 09:00:00');
	insert into list_test values( 4,7,7, 7.12345, 7.23456, 7.34567, 5.45678, 70,'2006-03-01 09:00:00');
	insert into list_test values( 5,9,9, 9.12345, 9.23456, 9.34567, 9.45678, 90,'2006-03-01 09:00:00');
	insert into list_test values( 6,1,1, 1.12345, 1.23456, 1.34567, 1.45678, 10,'2006-03-01 09:00:00');
	insert into list_test values( 7,3,3, 3.12345, 3.23456, 3.34567, 3.45678, 30,'2006-03-01 09:00:00');
	insert into list_test values( 8,5,5, 5.12345, 5.23456, 5.34567, 5.45678, 50,'2006-03-01 09:00:00');
	insert into list_test values( 9,7,7, 7.12345, 7.23456, 7.34567, 7.45678, 70,'2006-03-01 09:00:00');
	insert into list_test values(10,9,9, 9.12345, 9.23456, 9.34567, 9.45678, 90,'2006-03-01 09:00:00');
	insert into list_test values(11,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');
update list_test set test_int      = NULL where test_int      = 1;

select * from list_test order by id;


drop table list_test;
