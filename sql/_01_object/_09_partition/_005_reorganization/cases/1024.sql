-- create range partition table on int field having boundary values and add 3 partitions and then query all partitions and drop table

create table range_test(id int not null ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp,primary key(id,test_int))
PARTITION BY RANGE (test_int) (
    PARTITION p0 VALUES LESS THAN (10),
    PARTITION p1 VALUES LESS THAN (20),
    PARTITION p2 VALUES LESS THAN (30)
);

ALTER TABLE range_test add partition (
partition p4 values less than (100),
partition p5 values less than (200),
partition p6 values less than (300)
);
select * from db_partition order by 1,2;

drop class range_test;
