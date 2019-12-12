--[er]test insert(smallint) for list partition(have NULL value) with incorrect values out of range
create table list_test(id int not null,   
			test_int int,                 
			test_smallint smallint,       
			test_numeric numeric(38,10),  
			test_float float,             
			test_real real,               
			test_double double,           
			test_monetary monetary,       
			test_datetime timestamp,
                        primary key (id, test_smallint))      
	PARTITION BY LIST (test_smallint) (           
	PARTITION p0 VALUES IN (1,3,5,7,9,NULL)       
);                                                    

insert into list_test values( 4,14,15,14.399696514, 14.436700499, 14.363333523, 14.4, 14,'2006-03-01 09:00:00');
select * from list_test order by 1;


drop table list_test;
