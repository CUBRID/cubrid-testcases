--can not drop index after droping partition table

create table range_test(
   id int auto_increment not null,
   test_int int,primary key(id,test_int)
)
PARTITION BY RANGE (test_int) (
PARTITION p0 VALUES LESS THAN (10),
PARTITION p1 VALUES LESS THAN (20)
);

create index idx_int on range_test__p__p0 (test_int) with online parallel 5;
drop table range_test;
SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name like '%range%';
