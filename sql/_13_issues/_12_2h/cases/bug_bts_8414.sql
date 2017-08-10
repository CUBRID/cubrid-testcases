--TEST: [Analytic Functions] INCR and DECR doesn't work with ROW_NUMBER() function


create table z1 (a int, b int);
insert into z1 values (1, 1);

--test: incr() function with analytic functions 
select a, incr(a), ROW_NUMBER() over() c11 from z1;
select * from z1 order by 1;

select a, decr(b), ROW_NUMBER() over(PARTITION BY b) c11 from z1;
select * from z1 order by 1;

select a, incr(a), decr(b), ROW_NUMBER() over(PARTITION BY b) c11 from z1;
select * from z1 order by 1;

select a, decr(b), incr(a), ROW_NUMBER() over(PARTITION BY b order by a) c11 from z1;
select * from z1 order by 1;

select a, decr(b), incr(a), incr(a), decr(b), ROW_NUMBER() over(PARTITION BY b order by a) c11 from z1;
select * from z1 order by 1;


drop table z1;
