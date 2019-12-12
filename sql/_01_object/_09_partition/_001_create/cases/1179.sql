-- create table of range partition having boundary values and maxvalue on string field that using to_time  function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY range(to_time(store_id)) (
partition p0 values less than ('09:00:00'),
partition p1 values less than ('12:00:00'),
partition p2 values less than MAXVALUE);

select * from db_partition where class_name like '%za%'order by 2;


drop class za;
