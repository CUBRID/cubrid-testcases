autocommit off;
create class x (xint int);
create class sx as subclass of x;
select * from x
union
select * from sx;
rollback;
