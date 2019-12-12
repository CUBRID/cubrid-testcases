-- create a hash partition table on string field that using to_timestamp  function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY HASH(to_timestamp(store_id)) 
PARTITIONS 4; 

select * from db_partition where class_name like '%za%'  order by 1,2;


drop class za;