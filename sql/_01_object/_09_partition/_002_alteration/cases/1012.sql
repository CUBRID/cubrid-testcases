--test adding list partition(varchar type) using alter table command
create table list_test(id int ,        
			test_char char(50),                 
			test_varchar varchar(2000),         
			test_bit bit(16),                   
			test_varbit bit varying(20),        
			test_nchar nchar(50),               
			test_nvarchar nchar varying(2000),  
			test_string string,                 
			test_datetime timestamp, primary key(id, test_varchar)); 

insert into list_test values(1,'aaa','aaa',B'1',B'1011',N'aaa',N'aaa','aaaaaaaaaa','2006-03-01 09:00:00');  
insert into list_test values(2,'bbb','bbb',B'10',B'1100',N'bbb',N'bbb','bbbbbbbbbb','2006-03-01 09:00:00'); 
insert into list_test values(3,'ddd','ddd',B'100',B'1110',N'ddd',N'ddd','dddddddddd','2006-03-01 09:00:00');
insert into list_test values(4,'fff','fff',B'101',B'1111',N'fff',N'fff','ffffffffff','2006-03-01 09:00:00');
insert into list_test values(5,'ggg','ggg',B'101',B'1111',N'ggg',N'ggg','gggggggggg','2006-03-01 09:00:00');
insert into list_test values(6,'hhh','hhh',B'101',B'1111',N'hhh',N'hhh','hhhhhhhhhh','2006-03-01 09:00:00');
insert into list_test values(7,'kkk','kkk',B'101',B'1111',N'kkk',N'eee','kkkkkkkkkk','2006-03-01 09:00:00');
insert into list_test values(8,'lll','lll',B'101',B'1111',N'lll',N'eee','llllllllll','2006-03-01 09:00:00');
insert into list_test values(9,'mmm','mmm',B'101',B'1111',N'mmm',N'lll','mmmmmmmmmm','2006-03-01 09:00:00');
insert into list_test values(10, null,null,null,null,null,null,null,'2007-01-01 09:00:00');
ALTER TABLE list_test
PARTITION BY LIST (test_varchar) (                          
    PARTITION p0 VALUES IN ('aaa','bbb','ddd'),             
    PARTITION p1 VALUES IN ('fff','ggg','hhh',NULL),        
    PARTITION p2 VALUES IN ('kkk','lll','mmm')              
); 
select * from list_test order by id;
select * from list_test__p__p0 order by id;
select * from list_test__p__p1 order by id;
select * from list_test__p__p2 order by id;


drop table list_test;
