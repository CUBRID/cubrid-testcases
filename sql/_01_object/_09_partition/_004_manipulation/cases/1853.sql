-- insert data  whith create hash partition table on a date field with size 4 and delete data and  query data from every partition and then drop table

create table hash_test(id int,	
			   test_time time,
			   test_date date,
			   test_timestamp timestamp, primary key(id,test_date))
	PARTITION BY HASH(test_date)
        PARTITIONS 4;
insert into hash_test values(1,'08:10:00','2006-01-01','2006-01-01 08:10:00');
	insert into hash_test values(2,'08:20:00','2006-01-11','2006-01-11 08:20:00');
	insert into hash_test values(3,'09:10:00','2006-02-01','2006-02-01 09:10:00');
	insert into hash_test values(4,'09:20:00','2006-02-11','2006-02-11 09:20:00');
	insert into hash_test values(5,'09:30:00','2006-03-01','2006-03-01 10:30:00');
	insert into hash_test values(6,'10:10:00','2006-03-11','2006-03-11 10:40:00');
	insert into hash_test values(7,'10:20:00','2006-04-01','2006-04-01 11:50:00');
	insert into hash_test values(8,'11:30:00','2006-04-11','2006-04-11 11:30:00');
	insert into hash_test values(9,'11:10:00','2006-05-01','2006-05-01 12:40:00');
	insert into hash_test values(10,'12:20:00','2006-05-11','2006-05-11 12:50:00');
	insert into hash_test values(11,'13:10:00','2006-06-01','2007-01-01 08:10:00');
	insert into hash_test values(12,'13:20:00','2006-06-11','2007-01-11 08:20:00');
	insert into hash_test values(13,'14:10:00','2006-07-01','2007-02-01 09:10:00');
	insert into hash_test values(14,'14:20:00','2006-07-11','2007-02-11 09:20:00');
	insert into hash_test values(15,'15:30:00','2006-08-01','2007-03-01 10:30:00');
	insert into hash_test values(16,'15:10:00','2006-08-11','2007-03-11 10:40:00');
	insert into hash_test values(17,'16:20:00','2006-09-01','2007-04-01 11:50:00');
	insert into hash_test values(18,'16:30:00','2006-09-11','2007-04-11 11:30:00');
	insert into hash_test values(19,'17:10:00','2006-10-01','2007-05-01 12:40:00');
	insert into hash_test values(20,'17:20:00','2006-10-11','2007-05-11 12:50:00');

	insert into hash_test values(21,NULL,NULL,NULL);
delete from hash_test where test_date in ('2006-01-01','2006-04-11','2006-05-01','2006-08-01');
select * from hash_test order by id;
select * from hash_test__p__p0 order by id;
select * from hash_test__p__p1 order by id;
select * from hash_test__p__p2 order by id;
select * from hash_test__p__p3 order by id;



drop table hash_test;