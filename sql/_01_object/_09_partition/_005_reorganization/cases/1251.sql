-- [er]create range partition table on char field having boundary values and add a partition with a less range than first partition existing

create table range_test(id int not null ,
			test_int int,
			test_char char(50),
			test_varchar varchar(2000),
			test_datetime timestamp,primary key(id,test_char))
PARTITION BY RANGE (test_char) (
    PARTITION p0 VALUES LESS THAN ('ddd'),
    PARTITION p1 VALUES LESS THAN ('ggg'),
    PARTITION p2 VALUES LESS THAN ('kkk')
);

ALTER TABLE range_test add partition (
partition p7 values less than ('bbb')
);
select * from db_partition order by 1,2;

drop class range_test;
