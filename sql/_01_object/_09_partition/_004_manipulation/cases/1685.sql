-- [er]create range partition table with int field having boundary values that using parameter

evaluate 10 into :x; 

CREATE TABLE employees ( 
store_id INT NOT NULL 
) 
PARTITION BY RANGE (store_id) ( 
PARTITION p0 VALUES LESS THAN (:x), 
PARTITION p1 VALUES LESS THAN (10), 
PARTITION p3 VALUES LESS THAN MAXVALUE 
); 




drop class employees;
