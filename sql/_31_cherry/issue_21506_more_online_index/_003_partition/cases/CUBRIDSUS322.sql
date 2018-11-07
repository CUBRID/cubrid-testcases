--can not drop index after droping partition table

create table range_test(
   id int auto_increment not null,
   test_int int,primary key(id,test_int)
)
PARTITION BY RANGE (test_int) (
PARTITION p0 VALUES LESS THAN (10),
PARTITION p1 VALUES LESS THAN (20)
);

create index idx_int on range_test__p__p0 (test_int) with online;
drop table range_test;
select * from db_index where class_name like '%range%';
