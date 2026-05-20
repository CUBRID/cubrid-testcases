-- create a hash partition table on string field that using to_timestamp  function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY HASH(to_timestamp(store_id)) 
PARTITIONS 4; 

select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition where class_name like '%za%'  order by partition_name;


drop class za;
