--create list partiition table with a extract(year  from timestamp  date field) function 

create table list_test(id int,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp, primary key(id,test_timestamp))
	PARTITION BY LIST (extract(year from test_timestamp)) (
	PARTITION p0 VALUES IN (1991,1992,1993,1994,1995),
	PARTITION p1 VALUES IN (1996,1997,1998,1999,2000),
	PARTITION p2 VALUES IN (2001,2002,2003,2004,2005),
	PARTITION p3 VALUES IN (2006,2007,2008,2009,2010,null)
);
create index timestamp_idx on list_test (test_timestamp) with online;
	insert into list_test values(1,'09:00:00','1991-01-01','1991-01-01 09:00:00');
	insert into list_test values(2,'09:30:00','1992-01-11','1992-01-11 09:30:00');
	insert into list_test values(3,'09:50:00','1994-02-01','1994-02-01 09:50:00');
	insert into list_test values(4,'12:00:00','1995-02-11','1995-02-11 12:00:00');
	insert into list_test values(5,'12:30:00','1996-03-01','1996-03-01 12:30:00');
	insert into list_test values(6,'12:50:00','1997-03-11','1997-03-11 12:50:00');
	insert into list_test values(7,'15:00:00','1998-04-01','1998-04-01 15:00:00');
	insert into list_test values(8,'15:30:00','1999-04-11','1999-04-11 15:30:00');
	insert into list_test values(9,'15:50:00','2000-05-01','2000-05-01 15:50:00');
	insert into list_test values(10,'18:00:00','2001-06-11','2001-06-11 18:00:00');
	insert into list_test values(11,'18:30:00','2002-07-01','2002-07-01 18:30:00');
	insert into list_test values(12,'18:50:00','2003-07-11','2003-07-11 18:50:00');
	insert into list_test values(13,'21:00:00','2004-08-01','2004-08-01 21:00:00');
	insert into list_test values(14,'21:30:00','2005-08-11','2005-08-11 21:30:00');
	insert into list_test values(15,'21:50:00','2006-09-01','2006-09-01 21:50:00');
	insert into list_test values(16,'23:00:00','2007-09-11','2007-09-11 23:00:00');	
	insert into list_test values(20,null,null,null);
select * from list_test order by id;
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;
select * from list_test__p__p3 order by id;
update list_test set test_timestamp = '2008-01-01 15:30:00' where test_timestamp < '2000-01-01 15:30:00';
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;
select * from list_test__p__p3 order by id;

drop table list_test;
