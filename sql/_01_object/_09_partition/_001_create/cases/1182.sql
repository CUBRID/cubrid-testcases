-- create table of list partition  on string field that using to_time  function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY list(to_time(store_id)) (
partition p0 values in ('09:00:00', '09:10:00','09:20:00'),
partition p1 values in (null, '10:00:00','10:10:00','10:20:00','10:30:00'),
partition p2 values in  ('11:00:00','11:10:00','11:20:00','11:30:00'));


select * from db_partition where class_name like '%za%' order by partition_name;


drop class za;
