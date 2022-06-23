-- create a hash partition table on string field that using to_time   function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY HASH(to_time(store_id)) 
PARTITIONS 4; 

select * from db_partition where class_name like '%za%' order by partition_name;


drop class za;
