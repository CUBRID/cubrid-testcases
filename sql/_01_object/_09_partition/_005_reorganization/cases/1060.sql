-- insert data  whith create range partition table on a timestamp field and add a partition and then query data and drop table

create table range_test(id int not null ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp,primary key(id,test_datetime))
PARTITION BY RANGE (test_datetime) (
	PARTITION p0 VALUES LESS THAN ('2006-02-01 09:00:00'),
	PARTITION p1 VALUES LESS THAN ('2006-03-01 10:00:00'),
	PARTITION p2 VALUES LESS THAN ('2006-04-01 11:00:00')
);
insert into range_test values (1,1,'aaa','aaa','2006-01-01 09:00:00');
insert into range_test values (2,2,'bbb','bbb','2006-01-02 09:00:00');
insert into range_test values (3,3,'ccc','ccc','2006-01-03 09:00:00');
insert into range_test values (4,11,'ddd','ddd','2006-02-01 09:00:00');
insert into range_test values (5,12,'eee','eee','2006-02-02 09:00:00');
insert into range_test values (6,13,'fff','fff','2006-02-03 09:00:00');
insert into range_test values (7,21,'ggg','ggg','2006-03-01 09:00:00');
insert into range_test values (8,22,'hhh','hhh','2006-03-02 09:00:00');
insert into range_test values (9,23,'iii','iii','2006-03-03 09:00:00');

ALTER TABLE range_test add partition (
partition p3 values less than ('2006-05-01 11:00:00')
);
insert into range_test values (11,50,'kkk','kkk','2000-05-01 11:00:00');

select * from db_partition order by 1,2;
select * from range_test order by 1,2;

select * from range_test__p__p0 order by 1,2;
select * from range_test__p__p1 order by 1,2;
select * from range_test__p__p2 order by 1,2;
select * from range_test__p__p3 order by 1,2;

drop table range_test;
