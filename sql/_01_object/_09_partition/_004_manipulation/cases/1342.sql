--test insert(int) for list partition(have NULL value) with correct values within range
create table list_test(id int,   
			test_int int,                 
			test_smallint smallint,       
			test_numeric numeric(38,10),  
			test_float float,             
			test_real real,               
			test_double double,           
			test_monetary monetary,       
			test_datetime timestamp, primary key(id,test_int))      
	PARTITION BY LIST (test_int) (                
	PARTITION p0 VALUES IN (1,3,5,7,9,NULL)       
);                                                    

insert into list_test values( 1,1,1, 1.12345, 1.12345, 1.12345, 1.12345, 10,'2006-03-01 09:00:00'); 
insert into list_test values( 2,3,3, 2.34567, 2.34567, 2.34567, 2.34567, 20,'2006-03-01 09:00:00'); 
insert into list_test values( 3,5,5, 3.14568, 3.14568, 3.14568, 3.14568, 30,'2006-03-01 09:00:00'); 
select * from list_test order by 1;


drop table list_test;
