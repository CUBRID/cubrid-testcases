--test drand() for normal usage

create class xoo ( a int );
insert into xoo values(1);
insert into xoo values(2);
insert into xoo values(3);

select count(*) from (select drand() from xoo) x;
select count(*) from (select a from (select drand() from xoo) x (a) )x;
select count(*) from (select drand(), (select a from xoo x where x.a = y.a) 
from xoo y) xx;

select count(*) from (select drand() / 100 from xoo) x;
select count(*) from (select cast ( drand() as double) from xoo) x;
select count(*) from (select to_char ( drand() ) from xoo) x;
select count(*) from (select drand() + 100 from xoo) x;
select count(*) from (select drand() drand_x, drand() drand_y from xoo) x;

select count(*) from (select to_char(drand()) from xoo) x;
select count(*) from (select * from xoo) x;

drop xoo;
