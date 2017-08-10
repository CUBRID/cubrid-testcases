--test self join with list partition(timestamp)
create table list_test(id int,	
				   test_time time,
				   test_date date,
				   test_timestamp timestamp, primary key(id,test_timestamp))
		PARTITION BY LIST (test_timestamp) (
		PARTITION p0 VALUES IN ('2006-02-01 09:00:00','2006-02-11 09:00:00','2006-02-21 09:00:00'),
		PARTITION p1 VALUES IN ('2006-03-01 09:00:00','2006-03-11 09:00:00',null,'2006-03-21 09:00:00'),
		PARTITION p2 VALUES IN ('2006-04-01 09:00:00','2006-04-11 09:00:00','2006-04-21 09:00:00')
	);
insert into list_test values(1,'09:00:00','2006-02-01','2006-02-01 09:00:00'); 
insert into list_test values(2,'09:10:00','2006-02-11','2006-02-11 09:00:00'); 
insert into list_test values(3,'09:20:00','2006-02-21','2006-02-21 09:00:00'); 
insert into list_test values(4,'10:00:00','2006-03-01','2006-03-01 09:00:00'); 
insert into list_test values(5,'10:10:00','2006-03-11','2006-03-11 09:00:00'); 
insert into list_test values(6,'10:20:00','2006-03-21','2006-03-21 09:00:00'); 
insert into list_test values(7,'11:00:00','2006-04-01','2006-04-01 09:00:00'); 
insert into list_test values(8,'11:10:00','2006-04-11','2006-04-11 09:00:00'); 
insert into list_test values(9,'11:20:00','2006-04-21','2006-04-21 09:00:00'); 
insert into list_test values(11,'09:00:00','2006-02-01','2006-02-01 09:00:00');
insert into list_test values(12,'09:10:00','2006-02-11','2006-02-11 09:00:00');
insert into list_test values(13,'09:20:00','2006-02-21','2006-02-21 09:00:00');
insert into list_test values(14,'10:00:00','2006-03-01','2006-03-01 09:00:00');
insert into list_test values(15,'10:10:00','2006-03-11','2006-03-11 09:00:00');
insert into list_test values(16,'10:20:00','2006-03-21','2006-03-21 09:00:00');
insert into list_test values(17,'11:00:00','2006-04-01','2006-04-01 09:00:00');
insert into list_test values(18,'11:10:00','2006-04-11','2006-04-11 09:00:00');
insert into list_test values(19,'11:20:00','2006-04-21','2006-04-21 09:00:00');
insert into list_test values(50,NULL,NULL,NULL);

select * from list_test A, list_test B order by a.id,b.id;
select a.test_timestamp, b.test_timestamp from list_test A, list_test B where a.test_timestamp ='2006-02-01 09:00:00'
order by 1,2;


drop table list_test;
