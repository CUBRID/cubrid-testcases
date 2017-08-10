-- create table of hash partition having size 4 on time field that using to_char function and query all partitions

create table hash_test(id int,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp, 
                   primary key(id, test_time))
	PARTITION BY HASH (to_char(test_time,'hh24:mi:ss')) 
	PARTITIONS 4;
	insert into hash_test values(1,'09:01:11','1991-01-01','1991-01-01 09:00:00');
	insert into hash_test values(2,'09:32:22','1992-01-11','1992-01-11 09:30:00');
	insert into hash_test values(3,'09:53:33','1994-02-01','1994-02-01 09:50:00');
	insert into hash_test values(4,'12:04:44','1995-02-11','1995-02-11 12:00:00');
	insert into hash_test values(5,'12:35:55','1996-03-01','1996-03-01 12:30:00');
	insert into hash_test values(6,'12:56:16','1997-03-11','1997-03-11 12:50:00');
	insert into hash_test values(7,'15:07:27','1998-04-01','1998-04-01 15:00:00');
	insert into hash_test values(8,'15:38:38','1999-04-11','1999-04-11 15:30:00');
	insert into hash_test values(9,'15:59:49','2000-05-01','2000-05-01 15:50:00');
	insert into hash_test values(10,'18:01:51','2001-06-11','2001-06-11 18:00:00');
	insert into hash_test values(11,'18:32:12','2002-07-01','2002-07-01 18:30:00');
	insert into hash_test values(12,'18:53:23','2003-07-11','2003-07-11 18:50:00');
	insert into hash_test values(13,'21:04:34','2004-08-01','2004-08-01 21:00:00');
	insert into hash_test values(14,'21:35:45','2005-08-11','2005-08-11 21:30:00');
	insert into hash_test values(15,'21:56:56','2006-09-01','2006-09-01 21:50:00');
	insert into hash_test values(16,'23:07:07','2007-09-11','2007-09-11 23:00:00');	
	insert into hash_test values(20,null,null,null);
select * from hash_test__p__p0 order by id;
select * from hash_test__p__p1 order by id;
select * from hash_test__p__p2 order by id;
select * from hash_test__p__p3 order by id;


drop table hash_test;
