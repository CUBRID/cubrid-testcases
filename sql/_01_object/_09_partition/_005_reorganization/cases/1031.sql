-- create range partition table on timestamp field having boundary values and add 3 partitions and then query all partitions and drop table

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

ALTER TABLE range_test add partition (
	PARTITION p4 VALUES LESS THAN ('2006-06-01 09:00:00'),
	PARTITION p5 VALUES LESS THAN ('2006-07-01 10:00:00'),
	PARTITION p6 VALUES LESS THAN ('2006-08-01 11:00:00')
);
select * from db_partition order by 1,2;

drop class range_test;
