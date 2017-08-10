-- create table of list partition  on string field that using to_date function and query all partitions

CREATE TABLE za ( 
store_id string 
) 
PARTITION BY list(to_timestamp(store_id)) (
partition p0 values in ('1999-01-01', '1999-02-01','1999-03-01'),
partition p1 values in (null,'2002-01-01','2002-02-01','2002-03-01','2002-04-01'),
partition p2 values in  ('2007-01-01','2007-02-01','2007-03-01','2007-04-01'));


select * from db_partition where class_name like '%za%' order by 1,2,3,4,5,6,7;


drop class za;
