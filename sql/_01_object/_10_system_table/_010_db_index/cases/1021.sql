--Create index on range partition class and partition and retrieve information from db_index

create class range_test(id int auto_increment not null,
			test_int int,
                        primary key(id,test_int)
			)
	PARTITION BY RANGE (test_int) (
	PARTITION p0 VALUES LESS THAN (10),
	PARTITION p1 VALUES LESS THAN (20)	
);

create index idx_int on range_test__p__p0 (test_int);

insert into range_test (test_int) values(1);
insert into range_test (test_int) values(2);
insert into range_test (test_int) values(3);
insert into range_test (test_int) values(15);


select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name in ( 'range_test', 'range_test__p__p0') order by class_name;



drop class range_test;
