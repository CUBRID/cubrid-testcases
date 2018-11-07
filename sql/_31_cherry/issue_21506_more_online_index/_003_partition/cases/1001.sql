--create index on partition table
create table range_test(id int auto_increment not null,
			test_int int,primary key(id,test_int)
			)
	PARTITION BY RANGE (test_int) (
	PARTITION p0 VALUES LESS THAN (10),
	PARTITION p1 VALUES LESS THAN (20)	
);

create index idx_int on range_test__p__p0 (test_int) with online;

insert into range_test (test_int) values(1);
insert into range_test (test_int) values(2);
insert into range_test (test_int) values(3);
insert into range_test (test_int) values(15);


select * from range_test order by 1;


drop table range_test;
