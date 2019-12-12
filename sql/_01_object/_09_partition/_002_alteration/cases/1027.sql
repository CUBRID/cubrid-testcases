--test adding list partition(smallint type) using alter table command
create table list_test(id int,   
			test_int int,                 
			test_smallint smallint,       
			test_numeric numeric(38,10),  
			test_float float,             
			test_real real,               
			test_double double,           
			test_monetary monetary,       
			test_datetime timestamp, primary key(id, test_smallint)); 
insert into list_test values( 1,1,1, 1.1234, 1.1234, 1.1234, 1.1234, 10,'2006-03-01 09:00:00');        
insert into list_test values( 2,3,3, 3.257 , 3.257 , 3.257 , 3.257 , 12,'2006-03-01 09:00:00');        
insert into list_test values( 3,5,5, 5.456 , 5.456 , 5.456 , 5.456 , 14,'2006-03-01 09:00:00');        
insert into list_test values( 4,2, 2,  2.3456 , 2.3456 , 2.3456 , 2.3456 , 20,'2006-03-01 09:00:00');  
insert into list_test values( 5,4, 4,  4.85934, 4.85934, 4.85934, 4.85934, 22,'2006-03-01 09:00:00');  
insert into list_test values( 6,11,11,11.43567,11.43567,11.43567,11.43567, 32,'2006-03-01 09:00:00');  
insert into list_test values( 7,13,13,13.3457, 13.3457 ,13.3457 ,13.3457 , 34,'2006-03-01 09:00:00');  
insert into list_test values(10, null,null,null,null,null,null,null,'2007-01-01 09:00:00');
ALTER TABLE list_test	PARTITION BY LIST (test_smallint) (           
	PARTITION p0 VALUES IN (1,3,5,7,9),           
	PARTITION p1 VALUES IN (2,4,6,8,10,NULL),     
	PARTITION p2 VALUES IN (11,13,15,17,19)       
); 


select * from list_test order by id;
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;


drop table list_test;
