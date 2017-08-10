--[er]create range partition table with smallint data type and one partitions having no maxvalue,then insert data to this table,,then update the separator field value,the updated data is equal with the boundary of the separator value

create table range_test(id int not null,
				test_int int,
				test_smallint smallint,
				test_numeric numeric(38,10),
				test_float float,
				test_real real,
				test_double double,
				test_monetary monetary,
				test_datetime timestamp,
                                primary key (id, test_smallint))
		PARTITION BY RANGE (test_smallint) (
		PARTITION p0 VALUES LESS THAN (10)
	);
	insert into range_test values( 1,1,2,1.952491373,1.040967569,1.8889608756,1.438915955,1,'2007-01-01 09:00:00');
	insert into range_test values( 2,2,3,2.102201596,2.448271838,2.309828743,2.862653912,2,'2007-01-01 09:00:00');
	insert into range_test values( 3,3,4,3.500607386,3.2760446668,3.861596361,3.511043858,3,'2007-01-01 09:00:00');
update range_test set test_smallint =10  where test_smallint = 4;
select * from range_test  order by 1;


drop table range_test;
