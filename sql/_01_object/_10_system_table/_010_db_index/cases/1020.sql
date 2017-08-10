--Create index on range partition class and retrieve information from db_index

create class range_test(id int auto_increment not null,
			test_int int,
                       primary key(id,test_int)
			)
	PARTITION BY RANGE (test_int) (
	PARTITION p0 VALUES LESS THAN (10),
	PARTITION p1 VALUES LESS THAN (20)	
);


select index_name, is_unique, is_reverse, class_name, key_count
from   db_index
where  class_name = 'range_test';

drop class range_test;
