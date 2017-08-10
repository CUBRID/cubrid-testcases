drop table if exists z1;

create table z1 (a enum('A', 'B', 'C'));
insert into z1 values ('A');
insert into z1 values ('C');

--count/sum/avg on ENUM column can work well. this's good.
SELECT count(*), sum(a), avg(a) from z1;

--test:we expect MAX can work
SELECT max(a) from z1;

--test:we expect MIN can work
SELECT min(a) from z1;

 
drop table if exists z1;
