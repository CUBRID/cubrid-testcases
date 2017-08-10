-- create list partition table,insert data to this class,select data from these partition

create class list_test(a int auto_increment, b int) 
partition by list(a) 
( partition p0 values in (1,3,5,7,9), 
partition p1 values in (2,4,6,8,10), 
partition p2 values in (11,12,13,14) 
); 

insert into list_test(b) values(1); 
insert into list_test(b) values(2); 
insert into list_test(b) values(3); 
insert into list_test(b) values(4); 
insert into list_test(b) values(5); 
insert into list_test(b) values(6); 
insert into list_test(b) values(7); 
insert into list_test(b) values(8); 
insert into list_test(b) values(9); 
insert into list_test(b) values(10); 
insert into list_test(b) values(11); 
insert into list_test(b) values(12); 
insert into list_test(b) values(13); 
insert into list_test(b) values(14); 

select * from list_test__p__p0 order by 1; 
select * from list_test__p__p1 order by 1; 
select * from list_test__p__p2 order by 1;

drop class list_test;
