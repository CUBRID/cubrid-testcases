-- [er]create range partition table on varchar field having boundary values and maxvalue and add a partition with a less range than a existing

create table range_test(id int not null  ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp,primary key(id,test_varchar))
PARTITION BY RANGE (test_varchar) (
    PARTITION p0 VALUES LESS THAN ('ddd'),
    PARTITION p1 VALUES LESS THAN ('ggg'),
    PARTITION p2 VALUES LESS THAN ('kkk'),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);


ALTER TABLE range_test add partition (
partition p4 values less than ('mmm')
);

drop class range_test;
