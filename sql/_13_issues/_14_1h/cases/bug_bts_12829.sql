drop table if exists tb1;
create table tb1 (a int, b int);
insert into tb1 values (1, null);
insert into tb1 values (1, null);

select a, count(b) from tb1 group by a;
select count(b) from tb1;

select count(distinct b) from tb1 group by a;
select count(distinctrow b) from tb1 group by a;
select count(unique b) from tb1 group by a;
select count(all b) from tb1 group by a;

select /*+ NO_HASH_AGGREGATE */ a, count(b) from tb1 group by a;

select a, sum(b) from tb1 group by a;
select sum(b) from tb1;

insert into tb1 values (1, 2);
insert into tb1 values (1, 6);

select a, sum(b) from tb1 group by a;
select sum(b) from tb1;

select a, avg(b) from tb1 group by a;
select avg(b) from tb1;

drop table tb1;
create table tb1 (a int, b int);
insert into tb1 values (1, null);
insert into tb1 values (1, null);
insert into tb1 values (2, 2);
insert into tb1 values (2, 6);

select a, count(b) from tb1 group by a;
select count(b) from tb1;

select count(distinct b) from tb1 group by a;
select a, avg(b) from tb1 group by a;

drop table tb1;
