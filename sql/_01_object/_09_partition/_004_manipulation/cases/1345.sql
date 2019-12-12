--test insert(int) for list partition(have NULL value) with null value.
create table list_test(id int not null ,   
			test_int int,                 
			test_smallint smallint,       
			test_numeric numeric(38,10),  
			test_float float,             
			test_real real,               
			test_double double,           
			test_monetary monetary,       
			test_datetime timestamp,
                        primary key (id, test_int))      
	PARTITION BY LIST (test_int) (                
	PARTITION p0 VALUES IN (1,3,5,7,9,NULL)       
);                                                    

insert into list_test values(5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');
select * from list_test order by 1;


drop table list_test;
