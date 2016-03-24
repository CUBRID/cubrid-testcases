/-- this is to make sure we correctly deal with correlated subqueries which are  * not correlated to the first spec in the from list. 

autocommit off;

create class xx (xint int);
create class yy (yint int);
insert into xx values(1);
insert into xx values(2);
insert into xx values(3);
insert into yy values(10);
insert into yy values(20);
insert into yy values(30);
select (select yint from yy where yint = y0.yint),
       (select yint-1 from yy where yint = y0.yint)
from xx, yy y0;
rollback;
