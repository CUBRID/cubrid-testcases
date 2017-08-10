-- insert data  whith create range partition table on a int field witch using function of to_char and then query all partitions and drop table

create table range_test(id int,
			test_int int,
			test_smallint smallint,
            primary key(id,test_int))
		PARTITION BY RANGE (to_char(test_int)) (
		PARTITION p0 VALUES LESS THAN ('05'),
		PARTITION p1 VALUES LESS THAN ('10'),
		PARTITION p2 VALUES LESS THAN ('15'),
		PARTITION p3 VALUES LESS THAN MAXVALUE
	);
insert into range_test values( 1,1,1);
insert into range_test values( 2,2,2);
insert into range_test values( 3,3,3);
insert into range_test values( 4,4,4);
insert into range_test values( 5,5,5);
insert into range_test values( 6,6,6);
insert into range_test values( 7,7,7);	
insert into range_test values( 8,8,8);
insert into range_test values( 9,9,9);
insert into range_test values(10,10,10);
insert into range_test values(11,11,11);
insert into range_test values(12,12,12);
insert into range_test values(13,13,13);
insert into range_test values(14,14,14);
insert into range_test values(15,15,15);
insert into range_test values(16,16,16);
insert into range_test values(17,17,17);
insert into range_test values(18,18,18);
insert into range_test values(19,19,19);
insert into range_test values(20,20,20);
insert into range_test values(21,NULL,NULL);

select * from range_test order by id;
select * from range_test__p__p0 order by id;
select * from range_test__p__p1 order by id;
select * from range_test__p__p2 order by id;
select * from range_test__p__p3 order by id;


drop table range_test;
