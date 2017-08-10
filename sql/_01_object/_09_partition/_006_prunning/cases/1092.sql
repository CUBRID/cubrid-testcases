-- insert data  whith create hash partition class on a int field with size 8 and query data with operator of "-","+","/" and then drop class

create class hash_test (id int, 
			 test_int int,
			 test_char char(10))
partition by hash(test_int)
partitions 8;

insert into hash_test values(0,-1,'-1');
insert into hash_test values(1,1,'1');
insert into hash_test values(2,2,'2');
insert into hash_test values(3,11,'11');
insert into hash_test values(4,12,'12');
insert into hash_test values(5,21,'21');
insert into hash_test values(6,22,'22');
insert into hash_test values(7,2007,'2007');
insert into hash_test values(8,4,'4');
insert into hash_test values(9,5,'5');
insert into hash_test values(10,16,'16');
select * from hash_test where test_int = (-1 + 0);
select * from hash_test where test_int = (4/2);
select * from hash_test where test_int = (121/11);
select * from hash_test where -test_int = -1;
drop class hash_test;