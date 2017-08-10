-- create range partition table,insert data to this class,select data from these partition

create class range_test(a int auto_increment, b int) 
partition by range(a) 
( partition p0 values less than (3), 
partition p1 values less than (6), 
partition p2 values less than maxvalue 
); 

insert into range_test(b) values(1); 
insert into range_test(b) values(2); 
insert into range_test(b) values(3); 
insert into range_test(b) values(4); 
insert into range_test(b) values(5); 
insert into range_test(b) values(6); 
insert into range_test(b) values(7); 

select * from range_test__p__p0 order by 1; 
select * from range_test__p__p1 order by 1; 
select * from range_test__p__p2 order by 1;

drop class range_test;
