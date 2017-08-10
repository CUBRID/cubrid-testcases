--test range 

drop table if exists participant2;

CREATE TABLE participant2 (
    host_year INT,
    nation CHAR(50),
    gold INT,
    silver INT,
    bronze INT
)
PARTITION BY RANGE (host_year) (
    PARTITION before_1992 VALUES LESS THAN (1992),
    PARTITION before_2000 VALUES LESS THAN (2000)
);

INSERT INTO participant2 VALUES
(1992, 'China', 6, 4, 6),
(1992, 'Germany', 7, 4, 7),
(1996, 'Cuba', 9, 12, 9),
(1984, 'Romania', 11, 11, 7),
(1984, 'Italy', 11, 12, 7),
(1984, 'China', 11, 14, 15);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

select count(*) from participant2;
select count(*) from participant2__p__before_1992;
select count(*) from participant2__p__before_2000;

-- separate partition
ALTER TABLE participant2
REORGANIZE PARTITION before_1992 INTO (
  PARTITION before_1988 VALUES LESS THAN (1988),
  PARTITION before_1992 VALUES LESS THAN (1992)
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;
INSERT INTO participant2 VALUES
(1992, 'Cuba', 9, 9, 12),
(1992, 'Germany', 7, 4, 7),
(1996, 'China', 7, 11, 6),
(1996, 'Germany', 8, 1, 2),
(1988, 'France', 11, 9, 13);

select count(*) from participant2;
select count(*) from participant2__p__before_1988;
select count(*) from participant2__p__before_1992;
select count(*) from participant2__p__before_2000;

-- merge partition
ALTER TABLE participant2
REORGANIZE PARTITION before_1992, before_2000 INTO (
  PARTITION before_2000 VALUES LESS THAN (2000)
);
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;
select count(*) from participant2; 

-- drop partition
ALTER TABLE participant2 DROP PARTITION before_2000;
select * from participant2 where host_year < 2000 order by 1,2;
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;
--return error
INSERT INTO participant2 VALUES
(1996, 'Australia', 17, 19, 23),
(1992, 'Korea', 28, 16, 15),
(1996, 'Russia', 32, 17, 14);

-- add partition
ALTER TABLE participant2 ADD PARTITION (
  PARTITION before_1996 VALUES LESS THAN (1996),
  PARTITION last_one VALUES LESS THAN MAXVALUE
);
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant2' order by partition_name;

INSERT INTO participant2 VALUES
(2000, 'Cuba', 10, 11, 11),
(2000, 'China', 10, 12, 13),
(2000, 'Italy', 7, 9, 11),
(1996, 'Australia', 17, 19, 23),
(1992, 'Korea', 28, 16, 15),
(1996, 'Russia', 32, 17, 14),
(2004, 'Germany', 10, 18, 16),
(2004, 'Russia', 6, 6, 7),
(2004, 'Italy', 8, 5, 16),
(2000, 'France', 17, 16, 16),
(2004, 'United States of America', 26, 21, 16),
(2004, 'France', 27, 27, 38),
(1992, 'Korea', 28, 16, 15);

select count(*) from participant2;
select count(*) from participant2__p__before_1988;
select count(*) from participant2__p__before_1996;
select count(*) from participant2__p__last_one;


rename table participant2 as participant;
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant' order by partition_name;

-- promote
ALTER TABLE participant PROMOTE PARTITION before_1988, last_one;
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant' order by partition_name;
select count(*) from participant;
select count(*) from participant__p__before_1988;
select count(*) from participant__p__last_one;

INSERT INTO participant VALUES
(1984, 'Korea', 39, 25, 33),
(1984, 'United States of America', 44, 32, 25);

DROP participant__p__before_1988;
DROP participant__p__last_one;

-- remove partition
ALTER TABLE participant REMOVE PARTITIONING;
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt WHERE class_of.class_name LIKE 'participant%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'participant' order by partition_name;
select count(*) from participant;

-- alter to partition table 
ALTER TABLE participant PARTITION BY RANGE (host_year) (
    PARTITION before_2000 VALUES LESS THAN (2000),
    PARTITION before_2008 VALUES LESS THAN (2008)
);
select count(*) from participant;
select count(*) from participant__p__before_2000;
select count(*) from participant__p__before_2008;

DROP participant ;

