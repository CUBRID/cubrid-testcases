--test rand() for normal usage 

create class xoo ( a int );
insert into xoo values(1);
insert into xoo values(2);
insert into xoo values(3);

select count(*) from (select rand() from xoo) x;
select count(*) from (select a from (select rand() from xoo) x (a) )x;
select count(*) from (select rand(), (select a from xoo x where x.a = y.a) 
from xoo y) xx;

select count(*) from (select rand() / 100 from xoo) x;
select count(*) from (select cast ( rand() as double) from xoo) x;
select count(*) from (select to_char ( rand() ) from xoo) x;
select count(*) from (select rand() + 100 from xoo) x;
select count(*) from (select rand() rand_x, rand() rand_y from xoo) x;

insert into xoo select to_number(rand()) from xoo;
select count(*) from (select * from xoo) x;

drop xoo;
