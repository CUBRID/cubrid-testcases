--test insert(time) for list partition(have NULL value) with null value.
create table list_test(id int,	                         
			test_time time,                                          
			test_date date,                                          
			test_timestamp timestamp, primary key(id,test_time))                                
	PARTITION BY LIST (test_time) (                                          
	PARTITION p0 VALUES IN ('06:00:00 AM','07:00:00 AM','09:00:00 AM',NULL)  
);                                                                               

insert into list_test values(5,NULL,NULL,NULL);
select * from list_test order by 1;


drop table list_test;
