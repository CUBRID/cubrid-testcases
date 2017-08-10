drop table if exists t;

create table t(i int) partition by range(i)
(partition p1 values less than(30));

create index idx1 on t(i);

alter table t reorganize partition p1 into(
partition p11 values less than (10),
partition p12 values less than (30));

drop table if exists t;


drop table if exists  athlete2;
CREATE TABLE athlete2 (
    name VARCHAR (40), 
    event VARCHAR (30)
) PARTITION BY LIST (event) ( 
    PARTITION event1 VALUES IN ('Swimming', 'Athletics'),
    PARTITION event2 VALUES IN ('Judo', 'Taekwondo', 'Boxing'),
    PARTITION event3 VALUES IN ('Football', 'Basketball', 'Baseball')
);

create index idx_name on athlete2(name);

ALTER TABLE athlete2
REORGANIZE PARTITION event2 INTO (
    PARTITION event2_1 VALUES IN ('Judo'),
    PARTITION event2_2 VALUES IN ('Taekwondo', 'Boxing')
);

drop table if exists  athlete2;


