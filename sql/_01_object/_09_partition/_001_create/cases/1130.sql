--create list partiition table with cast function to change time data type to char data type as a partition value

create table list_test(id int,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp, primary key(id,test_time))
	PARTITION BY LIST (cast(test_time as char(12))) (
	PARTITION p0 VALUES IN ('09:00:00 AM','09:30:00 AM','09:50:00 AM','12:00:00 PM','12:30:00 PM'),
	PARTITION p1 VALUES IN ('12:50:00 PM','15:00:00 PM','15:30:00 PM','15:50:00 PM'),
	PARTITION p2 VALUES IN ('18:00:00 PM','18:30:00 PM','18:50:00 PM','21:00:00 PM'),
	PARTITION p3 VALUES IN ('21:30:00 PM','21:50:00 PM','23:00:00 PM',null)

);
	insert into list_test values(1,'09:00:00','1991-01-01','1991-01-01 09:00:00');
	insert into list_test values(2,'09:30:00','1992-01-11','1992-01-11 09:30:00');
	insert into list_test values(3,'09:50:00','1994-02-01','1994-02-01 09:50:00');
	insert into list_test values(4,'12:00:00','1995-02-11','1995-02-11 12:00:00');
	insert into list_test values(5,'12:30:00','1996-03-01','1996-03-01 12:30:00');
	insert into list_test values(6,'12:50:00','1997-03-11','1997-03-11 12:50:00');
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;
select * from list_test__p__p3 order by id;



drop class list_test;
