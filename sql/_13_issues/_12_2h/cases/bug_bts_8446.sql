drop table if exists z1;
drop table if exists z2;
drop table if exists z3;

create table z1 (a enum('A', 'B', 'C'), b enum('A', 'B', 'C'));
insert into z1 values (1, 1);
insert into z1 values (NULL, 1);
insert into z1 values ('A', NULL);
insert into z1 values ('A', 2);
insert into z1 values (3, 1);
insert into z1 values (1, 1);

--QUERY1: below result is correct. 
SELECT  a,b,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;

create table z2  as SELECT  a,b,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;
select * from z2;

create table z3  as SELECT b,a,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;
select * from z3;



drop table if exists z1;
drop table if exists z2;
drop table if exists z3;
create table z1 (a varchar(1), b char(1));
insert into z1 values ('1', '1');
insert into z1 values ('A', '2');
insert into z1 values ('3', '1');
insert into z1 values ('1', '1');

--QUERY1: below result is correct. 
SELECT  a,b,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;

create table z2  as SELECT  a,b,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;

select * from z2;

create table z3  as SELECT b,a,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;
select * from z3;





drop table if exists z1;
drop table if exists z2;
drop table if exists z3;
create table z1 (a varchar(1), b char(1)) partition by hash(b) partitions 2;
insert into z1 values ('1', '1');
insert into z1 values ('A', '2');
insert into z1 values ('3', '1');
insert into z1 values ('1', '1');

--QUERY1: below result is correct. 
SELECT  a,b,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;

create table z2  as SELECT  a,b,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;

select * from z2 order by 1;

create table z3  as SELECT b,a,row_number() over( partition by a order by b desc) c11 from z1 order by a, b desc;
select * from z3  order by 1;

drop table z1;
drop table z2;
drop table z3;





