create table x (i int);
insert into x values(1), (2), (3), (4), (5);

select 1 from db_root where random(1)=rand(1);

select i from x where rand(1) =rand(1) and random(1)=random(1) and  rand()=rand() and  random()!= random()  order by 1;

select 1 from db_root where drand(1)= drand(1);
select i from x where drand(1)=drand(1) and drandom(1)=drandom(1) and drand()= drand() and drandom()!= drandom() order by 1;
select i from x where drand(i)= drandom(i) order by 1;
drop table x;
