-- create table of hash partition having size 4 on int field that using to_char function and query all partitions

create table hash_test(id int,
			test_int int,
			test_smallint smallint,
            primary key(id,test_int))
		PARTITION BY HASH (to_char(test_int))
		PARTITIONS 4; 
insert into hash_test values( 1,1,1);
insert into hash_test values( 2,2,2);
insert into hash_test values( 3,3,3);
insert into hash_test values( 4,4,4);
insert into hash_test values( 5,5,5);
insert into hash_test values( 6,6,6);
insert into hash_test values( 7,7,7);	
insert into hash_test values( 8,8,8);
insert into hash_test values( 9,9,9);
insert into hash_test values(10,10,10);
insert into hash_test values(11,11,11);
insert into hash_test values(12,12,12);
insert into hash_test values(13,13,13);
insert into hash_test values(14,14,14);
insert into hash_test values(15,15,15);
insert into hash_test values(16,16,16);
insert into hash_test values(17,17,17);
insert into hash_test values(18,18,18);
insert into hash_test values(19,19,19);
insert into hash_test values(20,20,20);
insert into hash_test values(21,NULL,NULL);
select * from hash_test__p__p0 order by id;
select * from hash_test__p__p1 order by id;
select * from hash_test__p__p2 order by id;
select * from hash_test__p__p3 order by id;


drop table hash_test;
