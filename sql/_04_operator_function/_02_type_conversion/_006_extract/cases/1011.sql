-- insert data  whith create range partition table on a date field witch using function of extract year and then query all partitions and drop table

create table range_test(id int,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp,
                   primary key(id,test_date))
	PARTITION BY RANGE (extract(year from test_date)) (
	PARTITION p0 VALUES LESS THAN (2000),
	PARTITION p1 VALUES LESS THAN (2002),
	PARTITION p2 VALUES LESS THAN (2004),
	PARTITION p3 VALUES LESS THAN (2006),
	PARTITION p4 VALUES LESS THAN MAXVALUE

);
create index time_idx on range_test (test_time);
	insert into range_test values(1,'09:00:00','1991-01-01','1991-01-01 09:00:00');
	insert into range_test values(2,'09:30:00','1992-01-11','1992-01-11 09:30:00');
	insert into range_test values(3,'09:50:00','1994-02-01','1994-02-01 09:50:00');
	insert into range_test values(4,'12:00:00','1995-02-11','1995-02-11 12:00:00');
	insert into range_test values(5,'12:30:00','1996-03-01','1996-03-01 12:30:00');
	insert into range_test values(6,'12:50:00','1997-03-11','1997-03-11 12:50:00');
	insert into range_test values(7,'15:00:00','1998-04-01','1998-04-01 15:00:00');
	insert into range_test values(8,'15:30:00','1999-04-11','1999-04-11 15:30:00');
	insert into range_test values(9,'15:50:00','2000-05-01','2000-05-01 15:50:00');
	insert into range_test values(10,'18:00:00','2001-06-11','2001-06-11 18:00:00');
	insert into range_test values(11,'18:30:00','2002-07-01','2002-07-01 18:30:00');
	insert into range_test values(12,'18:50:00','2003-07-11','2003-07-11 18:50:00');
	insert into range_test values(13,'21:00:00','2004-08-01','2004-08-01 21:00:00');
	insert into range_test values(14,'21:30:00','2005-08-11','2005-08-11 21:30:00');
	insert into range_test values(15,'21:50:00','2006-09-01','2006-09-01 21:50:00');
	insert into range_test values(16,'23:00:00','2007-09-11','2007-09-11 23:00:00');	
	insert into range_test values(20,null,null,null);

select * from range_test order by id;
select * from range_test__p__p0 order by id;
select * from range_test__p__p1 order by id;
select * from range_test__p__p2 order by id;
select * from range_test__p__p3 order by id;
select * from range_test__p__p4 order by id;
update range_test set test_date = '2008-01-01' where test_date < '2000-01-01';
select * from range_test__p__p0 order by id;
select * from range_test__p__p1 order by id;
select * from range_test__p__p2 order by id;
select * from range_test__p__p3 order by id;
select * from range_test__p__p4 order by id;

drop table range_test;
