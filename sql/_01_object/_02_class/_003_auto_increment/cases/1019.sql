-- create hash partition table,insert data to this class,select data from these partition

create class hash_test(a int auto_increment, b int) 
partition by hash(a) 
partitions 4;

insert into hash_test(b) values(1); 
insert into hash_test(b) values(2); 
insert into hash_test(b) values(3); 
insert into hash_test(b) values(4); 
insert into hash_test(b) values(5); 
insert into hash_test(b) values(6); 
insert into hash_test(b) values(7); 
insert into hash_test(b) values(8); 
insert into hash_test(b) values(9); 
insert into hash_test(b) values(10); 
insert into hash_test(b) values(11); 
insert into hash_test(b) values(12); 
insert into hash_test(b) values(13); 
insert into hash_test(b) values(14); 

select * from hash_test__p__p0 order by 1; 
select * from hash_test__p__p1 order by 1; 
select * from hash_test__p__p2 order by 1;
select * from hash_test__p__p3 order by 1;

drop class hash_test;
