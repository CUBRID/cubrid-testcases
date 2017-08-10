--create range partition table with time data type,insert data to this table and select data in where clause with keyword 'in', 'not in', 'not null', 'not between','<>'

create table range_test(id int not null,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp,
                                   primary key (id, test_time))
		PARTITION BY RANGE (test_time) (
		PARTITION p0 VALUES LESS THAN ('09:00:00'),
		PARTITION p1 VALUES LESS THAN ('10:00:00'),
		PARTITION p2 VALUES LESS THAN MAXVALUE
	);

	insert into range_test values(1,'08:10:00','2006-01-01','2006-01-01 08:10:00');
	insert into range_test values(2,'08:20:00','2006-01-11','2006-01-11 08:20:00');
	insert into range_test values(3,'09:10:00','2006-02-01','2006-02-01 09:10:00');
	insert into range_test values(4,'09:20:00','2006-02-11','2006-02-11 09:20:00');
	insert into range_test values(5,'09:30:00','2006-02-21','2006-02-21 09:30:00');
	insert into range_test values(6,'10:10:00','2006-03-01','2006-03-01 09:40:00');
	insert into range_test values(7,'10:20:00','2006-03-11','2006-03-11 09:50:00');
	insert into range_test values(8,null,null,null);
select * from range_test where test_time in ('08:10:00','09:20:00','10:20:00') order by 1,2;
select * from range_test where test_time not in ('08:20:00', '09:30:00','10:20:00') order by 1,2;

select * from range_test where test_time is not null order by 1,2;
select * from range_test where test_time not between '08:20:00' and '10:10:00' order by 1,2;
select * from range_test where test_time <>'09:10:00' order  by 1;
select * from range_test where test_time <> '10:10:00' order by 1,2;
drop class range_test;
