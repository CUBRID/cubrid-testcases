create table tt(i int);
insert into tt values(2),(2),(3);

--select
select count(distinct i) from tt;
select count(i) from tt;
select count(distinct 5) from tt;
select count(5) from tt;

insert into tt values(5), (5), (6), (7), (8), (9);

--select after insertint again
select count(distinct i) from tt;
select count(i) from tt;
select count(distinct 50035456465) from tt;
select count(554653213213552) from tt;


drop table tt;
