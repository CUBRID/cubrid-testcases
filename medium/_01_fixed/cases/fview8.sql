autocommit off;
create class x(xint int);
insert into x values (42);
create view vx(x) as select x from x;
select vx, x from vx;
rollback;
