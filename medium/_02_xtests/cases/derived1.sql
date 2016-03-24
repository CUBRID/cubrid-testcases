autocommit off;
create class x (i int, r set of int, s set of int);
insert into x values (1, {1, 2, 3}, {2, 3, 4});
insert into x values (20, {40}, {50, 60});
select x.r
from x, table(x.r) as r(i)
where x.i = r.i;
select x.r
from x, table(x.r) as r(i)
where r.i = x.i;
select x.i, r.i, x.r
from x, table(x.r) as r(i);
select x.i, r.i, t.i, x.r, x.s
from x, table(x.r) as r(i), table(x.s) as t(i)
where r.i = t.i;
rollback work;
rollback;
