--test list partition

drop table if exists  athlete2;
drop table if exists  athlete;

CREATE TABLE athlete2 (
    name VARCHAR (40), 
    event VARCHAR (30)
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

INSERT into athlete2 values 
('Boris','Swimming'),
('Fjodor','Athletics'),
('Gavrie','Judo'),
('Ivan','Taekwondo'),
('Lesta','Boxing'),
('Sacha','Football'),
('Ustin','Basketball'),
('Vadim','Baseball'),
('Vladilen','Swimming'),
('Yakov','Athletics'),
('Yerik','Judo');

--alter to partition table
ALTER TABLE athlete2 PARTITION BY LIST (event) (
    PARTITION event1 VALUES IN ('Swimming', 'Athletics'),
    PARTITION event2 VALUES IN ('Judo', 'Taekwondo', 'Boxing'),
    PARTITION event3 VALUES IN ('Football', 'Basketball', 'Baseball')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

select * from athlete2__p__event1 order by 1;
select * from athlete2__p__event2 order by 1;
select * from athlete2__p__event3 order by 1;

--split partition
ALTER TABLE athlete2
REORGANIZE PARTITION event2 INTO (
    PARTITION event2_1 VALUES IN ('Judo'),
    PARTITION event2_2 VALUES IN ('Taekwondo', 'Boxing')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

select * from athlete2__p__event2_1 order by 1;
select * from athlete2__p__event2_2 order by 1;

--add partition
ALTER TABLE athlete2 ADD PARTITION (
  PARTITION event4 VALUES IN ('Hiking', 'Cycling'),
  PARTITION event5 VALUES IN ('Paragliding')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

INSERT into athlete2 values 
('Svetlana','Boxing'),
('Tanya','Cycling'),
('Vania','Hiking'),
('Vanya','Paragliding'),
('Yalena','Swimming'),
('Yeva','Cycling'),
('Zasha','Paragliding'),
('Zilya','Hiking');

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete2%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete2' order by partition_name;

--alter table  name
rename table athlete2 as athlete;

select * from athlete__p__event1 order by 1;
select * from athlete__p__event2_1 order by 1;
select * from athlete__p__event2_2 order by 1;
select * from athlete__p__event3 order by 1;
select * from athlete__p__event3 order by 1;
select * from athlete__p__event4 order by 1;
select * from athlete__p__event5 order by 1;

--merge partition
ALTER TABLE athlete
REORGANIZE PARTITION event5, event1 INTO (
    PARTITION event2 VALUES IN ('Paragliding', 'Swimming', 'Athletics')
);

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete' order by partition_name;

--drop partition
select count(*) from athlete__p__event2_1;
select count(*) from athlete;

ALTER TABLE athlete DROP PARTITION event2_1;

--return error
select count(*) from athlete__p__event2_1;
select count(*) from athlete;

SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete' order by partition_name;

--promote 
ALTER TABLE  athlete PROMOTE PARTITION event4;
select * from athlete order by 1;
select * from athlete__p__event4 order by 1;
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete' order by partition_name;

--remove partition
show tables like 'athlete';
ALTER TABLE  athlete REMOVE PARTITIONING;
show tables like 'athlete';
SELECT dt.class_of.partition, dt.class_of.class_name, dt.* FROM _db_partition dt
WHERE class_of.class_name LIKE 'athlete%' ORDER BY 2 ASC;
select * from db_partition where class_name = 'athlete' order by partition_name;

--drop table
DROP athlete;
DROP athlete__p__event4;

