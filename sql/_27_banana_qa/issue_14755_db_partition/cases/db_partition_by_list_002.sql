--test list partition

drop table if exists  athlete2;

CREATE TABLE athlete2 (
    name VARCHAR (40), 
    event VARCHAR (30)
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

ALTER TABLE athlete2 PARTITION BY LIST (event) (
    PARTITION event1 VALUES IN ('Swimming', 'Athletics'),
    PARTITION event2 VALUES IN ('Judo', 'Taekwondo', 'Boxing'),
    PARTITION event3 VALUES IN ('Football', 'Basketball', 'Baseball')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

ALTER TABLE athlete2
REORGANIZE PARTITION event2 INTO (
    PARTITION event2_1 VALUES IN ('Judo'),
    PARTITION event2_2 VALUES IN ('Taekwondo', 'Boxing')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

ALTER TABLE athlete2
REORGANIZE PARTITION event2_1, event2_2 INTO (
    PARTITION event2 VALUES IN ('Judo', 'Taekwondo', 'Boxing')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

ALTER TABLE athlete2 ADD PARTITION (
  PARTITION event4 VALUES IN ('Hiking', 'Cycling'),
  PARTITION event5 VALUES IN ('Paragliding')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

ALTER TABLE athlete2 DROP PARTITION event5;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

ALTER TABLE  athlete2 PROMOTE PARTITION event4;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

DROP athlete2__p__event4;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

ALTER TABLE  athlete2 REMOVE PARTITIONING;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

DROP athlete2;


