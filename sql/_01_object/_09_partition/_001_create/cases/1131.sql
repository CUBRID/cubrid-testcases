--create list partiition table with cast function to change date  data type to char data type as a partition value

create table list_test(id int,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp, primary key(id,test_date))
	PARTITION BY LIST (cast(test_date as char(15))) (
	PARTITION p0 VALUES IN ('01/01/1991',  '01/11/1992',  '02/01/1994',  '02/11/1995',  '03/01/1996'),
	PARTITION p1 VALUES IN ('03/11/1997',  '04/01/1998',  '04/11/1999',  '05/01/2000',  '06/11/2001'),
	PARTITION p2 VALUES IN ('07/01/2002',  '07/11/2003',  '08/01/2004',  '08/11/2005'),
	PARTITION p3 VALUES IN ('09/01/2006',  '09/11/2007',null)

);
	insert into list_test values(1,'09:00:00' ,'01/01/1991','1991-01-01 09:00:00');
	insert into list_test values(2,'09:30:00' ,'01/11/1992','1992-01-11 09:30:00');
	insert into list_test values(3,'09:50:00' ,'02/01/1994','1994-02-01 09:50:00');
	insert into list_test values(4,'12:00:00' ,'02/11/1995','1995-02-11 12:00:00');
	insert into list_test values(5,'12:30:00' ,'03/01/1996','1996-03-01 12:30:00');
	insert into list_test values(6,'12:50:00' ,'03/11/1997','1997-03-11 12:50:00');
	insert into list_test values(7,'15:00:00' ,'04/01/1998','1998-04-01 15:00:00');
	insert into list_test values(8,'15:30:00' ,'04/11/1999','1999-04-11 15:30:00');
	insert into list_test values(9,'15:50:00' ,'05/01/2000','2000-05-01 15:50:00');
	insert into list_test values(10,'18:00:00','06/11/2001','2001-06-11 18:00:00');
	insert into list_test values(11,'18:30:00','07/01/2002','2002-07-01 18:30:00');
	insert into list_test values(12,'18:50:00','07/11/2003','2003-07-11 18:50:00');
	insert into list_test values(13,'21:00:00','08/01/2004','2004-08-01 21:00:00');
	insert into list_test values(14,'21:30:00','08/11/2005','2005-08-11 21:30:00');
	insert into list_test values(15,'21:50:00','09/01/2006','2006-09-01 21:50:00');
	insert into list_test values(16,'23:00:00','09/11/2007','2007-09-11 23:00:00');	
insert into list_test values(20,null,null,null);
select * from list_test order by id;
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;
select * from list_test__p__p3 order by id;



drop class list_test;
