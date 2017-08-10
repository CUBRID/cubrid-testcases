--test update(smallint) for many list partition(have NULL value) with correct values within range
create table list_test(id int,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp, primary key(id,test_smallint))
		PARTITION BY LIST (test_smallint) (
		PARTITION p0 VALUES IN (1,3,5,7,9),
		PARTITION p1 VALUES IN (2,4,6,null,8,10),
		PARTITION p2 VALUES IN (11,13,15,17,19)
	);
	insert into list_test values( 1,1,1,1.1234   , 1.2345, 1.3456, 1.4567, 10,'2006-03-01 09:00:00');
	insert into list_test values( 2,3,3,3.1234   , 3.2345, 3.3456, 3.4567, 30,'2006-03-01 09:00:00');
	insert into list_test values( 3,5,5,5.1234   , 5.2345, 5.3456, 5.4567, 50,'2006-03-01 09:00:00');
	insert into list_test values( 4,7,7,7.1234   , 7.2345, 7.3456, 7.4567, 70,'2006-03-01 09:00:00');
	insert into list_test values( 5,9,9,9.1234   , 9.2345, 9.3456, 9.4567, 90,'2006-03-01 09:00:00');
	insert into list_test values( 6,1,1,1.1234   , 1.2345, 1.3456, 1.4567, 10,'2006-03-01 09:00:00');
	insert into list_test values( 7,3,3,3.1234   , 3.2345, 3.3456, 3.4567, 30,'2006-03-01 09:00:00');
	insert into list_test values( 8,5,5,5.1234   , 5.2345, 5.3456, 5.4567, 50,'2006-03-01 09:00:00');
	insert into list_test values( 9,7,7,7.1234   , 7.2345, 7.3456, 7.4567, 70,'2006-03-01 09:00:00');
	insert into list_test values(10,9,9,9.1234   , 9.2345, 9.3456, 9.4567, 90,'2006-03-01 09:00:00');
	insert into list_test values(11,2,2,2.1234   , 2.2345, 2.3456, 2.4567, 20,'2006-03-01 09:00:00');
	insert into list_test values(12,4,4,4.1234   , 4.2345, 4.3456, 4.4567, 40,'2006-03-01 09:00:00');
	insert into list_test values(13,6,6,6.1234   , 6.2345, 6.3456, 6.4567, 60,'2006-03-01 09:00:00');
	insert into list_test values(14,8,8,8.1234   , 8.2345, 8.3456, 8.4567, 80,'2006-03-01 09:00:00');
	insert into list_test values(15,10,10,10.1234,10.2345,10.3456,10.4567,100,'2006-03-01 09:00:00');
	insert into list_test values(16,2,2,2.1234   , 2.2345, 2.3456, 2.4567, 20,'2006-03-01 09:00:00');
	insert into list_test values(17,4,4,4.1234   , 4.2345, 4.3456, 4.4567, 40,'2006-03-01 09:00:00');
	insert into list_test values(18,6,6,6.1234   , 6.2345, 6.3456, 6.4567, 60,'2006-03-01 09:00:00');
	insert into list_test values(19,8,8,8.1234   , 8.2345, 8.3456, 8.4567, 80,'2006-03-01 09:00:00');
	insert into list_test values(20,10,10,10.1234,10.2345,10.3456,10.4567,100,'2006-03-01 09:00:00');
	insert into list_test values(21,11,11,11.1234,11.2345,11.3456,11.4567,110,'2006-03-01 09:00:00');
	insert into list_test values(22,13,13,13.1234,13.2345,13.3456,13.4567,130,'2006-03-01 09:00:00');
	insert into list_test values(23,15,15,15.1234,15.2345,15.3456,15.4567,150,'2006-03-01 09:00:00');
	insert into list_test values(24,17,17,17.1234,17.2345,17.3456,17.4567,170,'2006-03-01 09:00:00');
	insert into list_test values(25,19,19,19.1234,19.2345,19.3456,19.4567,190,'2006-03-01 09:00:00');
	insert into list_test values(26,11,11,11.1234,11.2345,11.3456,11.4567,110,'2006-03-01 09:00:00');
	insert into list_test values(27,13,13,13.1234,13.2345,13.3456,13.4567,130,'2006-03-01 09:00:00');
	insert into list_test values(28,15,15,15.1234,15.2345,15.3456,15.4567,150,'2006-03-01 09:00:00');
	insert into list_test values(29,17,17,17.1234,17.2345,17.3456,17.4567,170,'2006-03-01 09:00:00');
	insert into list_test values(30,19,19,19.1234,19.2345,19.3456,19.4567,190,'2006-03-01 09:00:00');
	insert into list_test values(50,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');
	update list_test set test_smallint      = 7 where test_smallint = 1;
	update list_test set test_smallint      = 10 where test_smallint = 2;
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;


drop table list_test;
