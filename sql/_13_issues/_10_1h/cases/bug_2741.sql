create table range_test(id int, parentid int, text varchar(32) ) PARTITION BY RANGE (id)
(
	PARTITION p0 VALUES LESS THAN (3),
	PARTITION p1 VALUES LESS THAN (5),
	PARTITION p2 VALUES LESS THAN (7),
	PARTITION p3 VALUES LESS THAN maxvalue );

create index range_test_idx on range_test(id,parentid);

alter index range_test_idx on range_test rebuild;

drop index range_test_idx on range_test;

drop table range_test;
