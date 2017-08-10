--test range 

drop table if exists participant2;

CREATE TABLE participant2 (
    host_year INT,
    nation CHAR(3),
    gold INT,
    silver INT,
    bronze INT
)
PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.*  FROM _db_partition dt 
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

ALTER TABLE participant2
REORGANIZE PARTITION before_2000 INTO (
  PARTITION before_1996 VALUES LESS THAN (1996),
  PARTITION before_2000 VALUES LESS THAN (2000)
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt  
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

ALTER TABLE participant2
REORGANIZE PARTITION before_1996, before_2000 INTO (
  PARTITION before_2000 VALUES LESS THAN (2000)
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

ALTER TABLE participant2 ADD PARTITION (
  PARTITION before_2012 VALUES LESS THAN (2012),
  PARTITION last_one VALUES LESS THAN MAXVALUE
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

ALTER TABLE participant2 DROP PARTITION before_2000;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

ALTER TABLE participant2 PROMOTE PARTITION before_2008, before_2012;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

DROP participant2__p__before_2008;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

DROP participant2__p__before_2012;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

ALTER TABLE participant2 REMOVE PARTITIONING;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

DROP participant2 ;

