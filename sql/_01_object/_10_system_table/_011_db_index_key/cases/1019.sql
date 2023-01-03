--Create index on range partition class and partition and retrieve information from db_index_key

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

select index_name, class_name, key_attr_name, key_order
from   db_index_key
where  class_name in ( 'range_test', 'range_test__p__p0')
order by index_name, key_attr_name, key_order;



drop class range_test;
