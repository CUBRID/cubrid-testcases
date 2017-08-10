--test adding list partition(date type) using alter table command
create table list_test(id int,	                        
			   test_time time,                                      
			   test_date date,                                      
			   test_timestamp timestamp, primary key(id, test_date)); 
insert into list_test values(1,'09:00:00','2006-02-01','2006-02-01 09:00:00');
insert into list_test values(2,'09:10:00','2006-02-11','2006-02-11 09:00:00');
insert into list_test values(3,'09:20:00','2006-02-21','2006-02-21 09:00:00');
insert into list_test values(4,'10:00:00','2006-03-01','2006-03-01 09:00:00');
insert into list_test values(5,'10:10:00','2006-03-11','2006-03-11 09:00:00');
insert into list_test values(6,'11:00:00','2006-04-01','2006-04-01 09:00:00');
insert into list_test values(7,'11:10:00','2006-04-11','2006-04-11 09:00:00');
insert into list_test values(10, null,null,null);
ALTER TABLE list_test	PARTITION BY LIST (test_date) (                                         
	PARTITION p0 VALUES IN ('2006-02-01','2006-02-11','2006-02-21'),        
	PARTITION p1 VALUES IN ('2006-03-01','2006-03-11','2006-03-21',NULL),   
	PARTITION p2 VALUES IN ('2006-04-01','2006-04-11','2006-04-21')         
); 


select * from list_test order by id;
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;


drop table list_test;
