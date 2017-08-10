--[er]create range partition table with null partition value for a not null field

CREATE TABLE employees ( 
store_id INT NOT NULL 
) 
PARTITION BY RANGE (store_id) ( 
PARTITION p0 VALUES LESS THAN (null), 
PARTITION p1 VALUES LESS THAN (100) 
);

drop class range_test;
