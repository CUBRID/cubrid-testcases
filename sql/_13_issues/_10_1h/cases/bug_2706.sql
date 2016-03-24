--1

--2
autocommit on;
select rand(1), random(1);
select rand(2147483647), random(2147483647);
select rand(-2147483648), random(-2147483648);
select 1 from db_root where drand(1) = drandom(1);
select 1 from db_root where drand(2147483647)= drandom(2147483647);
select 1 from db_root where drand(-2147483648)= drandom(-2147483648);

--3

--4

--5

--6
select rand(1.4), random(1.4) where drand(1.4) = drandom(1.4); 
select rand(1), random(1) where drand(1) = drandom(1);

select rand(1.5), random(1.5) where drand(1.5) = drandom(1.5);
select rand(2), random(2) where drand(2) = drandom(2);


--7
select rand(-2147483649);
select rand(2147483648);
select rand('string');
select rand(n'nstring');
select rand(time'21:43:00');
select rand(date'2010-04-20');
select rand(datetime'2010-04-20 21:43:00');

select random(-2147483649);
select random(2147483648);
select random('string');
select random(n'nstring');
select random(time'21:43:00');
select random(date'2010-04-20');
select random(datetime'2010-04-20 21:43:00');

select drand(-2147483649);
select drand(2147483648);
select drand('string');
select drand(n'nstring');
select drand(time'21:43:00');
select drand(date'2010-04-20');
select drand(datetime'2010-04-20 21:43:00');

select drandom(-2147483649);
select drandom(2147483648);
select drandom('string');
select drandom(n'nstring');
select drandom(time'21:43:00');
select drandom(date'2010-04-20');
select drandom(datetime'2010-04-20 21:43:00');


--8
select rand(NULL), rand(0), random(NULL), random(0);
select 1 from db_root where drand(NULL) = drand(0) and drandom(NULL) = drandom(0);


--9



--10
create table range_part (id int)
partition by range (rand(id))
(
partition under_half values less than (1073741823),
partition over_half values less than (2147483647)
);
insert into range_part values(1), (2);
select * from range_part__p__under_half order by 1;
select * from range_part__p__over_half order by 1;
drop table range_part;

create table list_part (id int)
partition by list (random(id))
(
partition id_1 values in (89400484),
partition id_2 values in (1959434203)
);
insert into list_part values(1), (2);
select * from list_part__p__id_1 order by 1;
select * from list_part__p__id_2 order by 1;
drop table list_part;

create table hash_part (id int)
partition by hash (rand(id)) partitions 3;
insert into hash_part values(1), (2), (3), (4), (5);
select * from hash_part__p__p0 order by 1;
select * from hash_part__p__p1 order by 1;
select * from hash_part__p__p2 order by 1;
drop table hash_part;


--11
create table foo (id1 int, id2 int, id3 int, id4 int);
insert into foo values(1,1,1,1), (2,2,2,2), (3,3,3,3), (4,4,4,4), (5,5,5,5);
select rand(id1), random(id2) from foo where drand(id3) = drandom(id4) order by 1; 
select rand(id1), rand(id2), random(id3), random(id4) from foo order by 1;
select 1 from foo where drand(id1)= drand(id2) and drandom(id3)= drandom(id4);
drop table foo;














