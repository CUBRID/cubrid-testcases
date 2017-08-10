--test insert(string) for many list partition(have NULL value) with null value.
create table list_test(id int not null ,                       
			test_char char(50),                                
			test_varchar varchar(2000),                        
			test_bit bit(16),                                  
			test_varbit bit varying(20),                       
			test_nchar nchar(50),                              
			test_nvarchar nchar varying(2000),                 
			test_string string,                                
			test_datetime timestamp,
                        primary key (id, test_string))                           
PARTITION BY LIST (test_string) (                                          
    PARTITION p0 VALUES IN ('aaaaaaaaaa','bbbbbbbbbb','dddddddddd'),       
    PARTITION p1 VALUES IN ('ffffffffff','gggggggggg','hhhhhhhhhh',NULL),  
    PARTITION p2 VALUES IN ('kkkkkkkkkk','llllllllll','mmmmmmmmmm')        
);                                                                         

insert into list_test values(11,'fff','fff',B'101',B'1111',N'fff',N'fff','ffffffffff','2006-03-01 09:00:00');
insert into list_test values(12,'ggg','ggg',B'101',B'1111',N'ggg',N'ggg','gggggggggg','2006-03-01 09:00:00');
insert into list_test values(13,'hhh','hhh',B'101',B'1111',N'hhh',N'hhh','hhhhhhhhhh','2006-03-01 09:00:00');
insert into list_test values(14,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');
select * from list_test order by id;


drop table list_test;
