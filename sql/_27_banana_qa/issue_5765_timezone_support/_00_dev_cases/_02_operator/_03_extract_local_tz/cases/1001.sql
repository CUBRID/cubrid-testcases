-- insert data  whith create range partition table on a timeltz field witch using function of extract hour  and then query all partitions and drop table

set timezone '+9:00';
create table range_test(id int not null,	
				   test_date date,
				   test_timestamp timestampltz,
				   primary key (id, test_timestamp))
	PARTITION BY RANGE (extract(hour from test_timestamp)) (
	PARTITION p0 VALUES LESS THAN (9),
	PARTITION p1 VALUES LESS THAN (12),
	PARTITION p2 VALUES LESS THAN (15),
	PARTITION p3 VALUES LESS THAN (18),
	PARTITION p4 VALUES LESS THAN (21),
	PARTITION p5 VALUES LESS THAN MAXVALUE

);

	insert into range_test values(1,'1991-01-01','1991-01-01 09:00:00');
	insert into range_test values(2,'1992-01-11','1992-01-11 09:30:00');
	insert into range_test values(3,'1994-02-01','1994-02-01 09:50:00');
	insert into range_test values(4,'1995-02-11','1995-02-11 12:00:00');
	insert into range_test values(5,'1996-03-01','1996-03-01 12:30:00');
	insert into range_test values(6,'1997-03-11','1997-03-11 12:50:00');
	insert into range_test values(7,'1998-04-01','1998-04-01 15:00:00');
	insert into range_test values(8,'1999-04-11','1999-04-11 15:30:00');
	insert into range_test values(9,'2000-05-01','2000-05-01 15:50:00');
	insert into range_test values(10,'2001-06-11','2001-06-11 18:00:00');
	insert into range_test values(11,'2002-07-01','2002-07-01 18:30:00');
	insert into range_test values(12,'2003-07-11','2003-07-11 18:50:00');
	insert into range_test values(13,'2004-08-01','2004-08-01 21:00:00');
	insert into range_test values(14,'2005-08-11','2005-08-11 21:30:00');
	insert into range_test values(15,'2006-09-01','2006-09-01 21:50:00');
	insert into range_test values(16,'2007-09-11','2007-09-11 23:00:00');	
	insert into range_test values(20,null,null);

select * from range_test__p__p0 order by id;
select * from range_test__p__p1 order by id;
select * from range_test__p__p2 order by id;
select * from range_test__p__p3 order by id;
select * from range_test__p__p4 order by id;
select * from range_test__p__p5 order by id;


drop table range_test;
set timezone 'default';
