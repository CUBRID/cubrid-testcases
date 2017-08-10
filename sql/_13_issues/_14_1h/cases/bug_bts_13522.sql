autocommit off;
SET SYSTEM PARAMETERS 'insert_execution_mode=0';

drop table if exists range_part;
create table range_part (id int) partition by range (rand(id))
(
partition under_half values less than (1073741823),
partition over_half values less than (2147483647)
);
insert into range_part values(1), (2);
select * from range_part__p__under_half order by 1;
select * from range_part__p__over_half order by 1;

drop table if exists list_part;
create table list_part (id int) partition by list (random(id))
(
partition id_1 values in (89400484),
partition id_2 values in (1959434203)
);
insert into list_part values(1), (2);
select * from list_part__p__id_1 order by 1;
select * from list_part__p__id_2 order by 1;

drop table if exists hash_part;
create table hash_part (id int)
partition by hash (rand(id)) partitions 3;

insert into hash_part values(1), (2), (3), (4), (5);
select * from hash_part__p__p0 order by 1;
select * from hash_part__p__p1 order by 1;
select * from hash_part__p__p2 order by 1;

SET SYSTEM PARAMETERS 'insert_execution_mode=3';

drop table if exists range_part;
create table range_part (id int) partition by range (rand(id))
(
partition under_half values less than (1073741823),
partition over_half values less than (2147483647)
);
insert into range_part values(1), (2);
select * from range_part__p__under_half order by 1;
select * from range_part__p__over_half order by 1;

drop table if exists list_part;
create table list_part (id int) partition by list (random(id))
(
partition id_1 values in (89400484),
partition id_2 values in (1959434203)
);
insert into list_part values(1), (2);
select * from list_part__p__id_1 order by 1;
select * from list_part__p__id_2 order by 1;

drop table if exists hash_part;
create table hash_part (id int)
partition by hash (rand(id)) partitions 3;

insert into hash_part values(1), (2), (3), (4), (5);
select * from hash_part__p__p0 order by 1;
select * from hash_part__p__p1 order by 1;
select * from hash_part__p__p2 order by 1;

drop table range_part;
drop table hash_part;
drop table list_part;
rollback;


autocommit on;
