--test inserting all data from non-partition to partition using two tables and select-insert(string)
create table list_test(id int ,       
			test_char char(50),                
			test_varchar varchar(2000),        
			test_bit bit(16),                  
			test_varbit bit varying(20),       
			test_nchar nchar(50),              
			test_nvarchar nchar varying(2000), 
			test_string string,                
			test_datetime timestamp, primary key(id,test_string))           
    PARTITION BY LIST (test_string) (                                          
    PARTITION p0 VALUES IN ('aaaaaaaaaa','bbbbbbbbbb','dddddddddd'),       
    PARTITION p1 VALUES IN ('ffffffffff','gggggggggg','hhhhhhhhhh',NULL),  
    PARTITION p2 VALUES IN ('kkkkkkkkkk','llllllllll','mmmmmmmmmm')        
); 

create table list_test2(id int ,       
			test_char char(50),                
			test_varchar varchar(2000),        
			test_bit bit(16),                  
			test_varbit bit varying(20),       
			test_nchar nchar(50),              
			test_nvarchar nchar varying(2000), 
			test_string string,                
			test_datetime timestamp, primary key(id,test_string));
insert into list_test2 values(1,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2006-03-01 09:00:00');  
insert into list_test2 values(2,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2006-03-01 09:00:00'); 
insert into list_test2 values(3,'ddd','ddd',B'100',B'1110',N'ddd',N'ddd','dddddddddd','2006-03-01 09:00:00');
insert into list_test2 values(4,'fff','fff',B'101',B'1111',N'fff',N'fff','ffffffffff','2006-03-01 09:00:00');
insert into list_test2 values(5,'ggg','ggg',B'101',B'1111',N'ggg',N'ggg','gggggggggg','2006-03-01 09:00:00');
insert into list_test2 values(6,'hhh','hhh',B'101',B'1111',N'hhh',N'hhh','hhhhhhhhhh','2006-03-01 09:00:00');
insert into list_test2 values(7,'kkk','kkk',B'101',B'1111',N'kkk',N'eee','kkkkkkkkkk','2006-03-01 09:00:00');
insert into list_test2 values(8,'lll','lll',B'101',B'1111',N'lll',N'eee','llllllllll','2006-03-01 09:00:00');
insert into list_test2 values(9,'mmm','mmm',B'101',B'1111',N'mmm',N'lll','mmmmmmmmmm','2006-03-01 09:00:00');
insert into list_test2 values(14,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2006-03-01 09:00:00');


insert into list_test select * from list_test2;
select * from list_test order by id;
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;


drop table list_test;
drop table list_test2;
