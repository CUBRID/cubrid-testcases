--test insert(date) for many list partition(have NULL value) with null value.
create table list_test(id int,	                       
			   test_time time,                                     
			   test_date date,                                     
			   test_timestamp timestamp, primary key(id,test_date))                           
	PARTITION BY LIST (test_date) (                                        
	PARTITION p0 VALUES IN ('2006-02-01','2006-02-11','2006-02-21'),       
	PARTITION p1 VALUES IN ('2006-03-01','2006-03-11','2006-03-21',NULL),  
	PARTITION p2 VALUES IN ('2006-04-01','2006-04-11','2006-04-21')        
);                                                                             

insert into list_test values(4,'10:00:00','2006-03-01','2006-03-01 09:00:00');
insert into list_test values(5,'10:10:00','2006-03-11','2006-03-11 09:00:00');
insert into list_test values(9,NULL,NULL,NULL);         
select * from list_test order by 1;


drop table list_test;
