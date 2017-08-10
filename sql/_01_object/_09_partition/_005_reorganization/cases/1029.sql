-- [er]create range partition table on int field having boundary values and maxvalue and add a partition with a less range than a existing

create table range_test(id int not null ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp,primary key(id,test_int))
PARTITION BY RANGE (test_int) (
    PARTITION p0 VALUES LESS THAN (10),
    PARTITION p1 VALUES LESS THAN (20),
    PARTITION p2 VALUES LESS THAN (30),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);


ALTER TABLE range_test add partition (
partition p4 values less than (50)
);

drop class range_test;
