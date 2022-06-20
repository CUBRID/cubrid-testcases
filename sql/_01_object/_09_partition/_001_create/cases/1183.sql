-- create table of list partition  on string field that using to_timestamp function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY list(to_timestamp(store_id)) (
partition p0 values in ('1999-01-01 09:00:00', '1999-01-01 09:10:00','1999-01-01 09:20:00'),
partition p1 values in (null,'2002-01-01 10:00:00','2002-01-01 10:10:00','2002-01-01 10:20:00','2002-01-01 10:30:00'),
partition p2 values in  ('2007-01-01 11:00:00','2007-01-01 11:10:00','2007-01-01 11:20:00','2007-01-01 11:30:00'));



select * from db_partition where class_name like '%za%' order by partition_name;


drop class za;
