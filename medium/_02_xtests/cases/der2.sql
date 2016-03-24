autocommit off;
create class x (i int, r set of int, s set of int);
insert into x values (1, {1, 2, 3}, {2, 3, 4});
insert into x values (20, {40}, {50, 60});
select x1.i, x2.i, x3.i, rs.i, x1.r, x2.s
from x x1, x x2, table(x1.r + x2.s) as rs(i), x x3
where x1.i = x2.i and x3.i < rs.i;
rollback;
