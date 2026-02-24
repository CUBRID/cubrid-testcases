--test hash partition

drop table if exists  nation2;

CREATE TABLE nation2 (
  code CHAR (3),
  name VARCHAR (50)
)
PARTITION BY HASH (code) PARTITIONS 4; 

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition where class_name = 'nation2' order by partition_name;

ALTER TABLE nation2 ADD PARTITION PARTITIONS 3;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition where class_name = 'nation2' order by partition_name;

ALTER TABLE nation2 COALESCE PARTITION 1;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition where class_name = 'nation2' order by partition_name;

ALTER TABLE nation2 REMOVE PARTITIONING;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'nation2%' ORDER BY 2 ASC;
select class_name, owner_name, partition_name, partition_class_name, partition_type, partition_expr, partition_values, class_partition_type, comment from db_partition where class_name = 'nation2' order by partition_name;

DROP nation2;

