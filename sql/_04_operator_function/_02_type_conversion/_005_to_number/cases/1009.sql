-- create table of hash partition having size 4 on char field that using cast function to int and query all partitions

create table hash_test(id int,
				test_char char(50),
				test_varchar varchar(50),
                primary key(id, test_char))
	PARTITION BY HASH (cast (test_char as int)) 
	PARTITIONS 4;

insert into hash_test values(1,'01','01');
	insert into hash_test values(2,'02','02');
	insert into hash_test values(3,'03','03');
	insert into hash_test values(4,'04','04');
	insert into hash_test values(5,'05','05');
	insert into hash_test values(6,'06','06');
	insert into hash_test values(7,'07','07');
	insert into hash_test values(8,'08','08');
	insert into hash_test values(9,'09','09');
	insert into hash_test values(10,'10','10');
	insert into hash_test values(11,'11','11');

	insert into hash_test values(12, null,null);
select * from 	 hash_test__p__p0 order by 1;
select * from    hash_test__p__p1 order by 1;
select * from    hash_test__p__p2 order by 1;
select * from    hash_test__p__p3 order by 1;


drop class hash_test;
