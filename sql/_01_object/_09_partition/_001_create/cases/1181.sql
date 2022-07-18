-- create table of range partition having boundary values and maxvalue on string field that using to_timestamp  function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY range(to_timestamp(store_id)) (
partition p0 values less than ('1999-01-01 09:00:00'),
partition p1 values less than ('2003-01-01 09:00:00'),
partition p2 values less than MAXVALUE);

select * from db_partition where class_name like '%za%' order by partition_name;


drop class za;
