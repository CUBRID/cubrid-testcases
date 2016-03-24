autocommit off;
create class z (c int);
create class w (b int);
create class x (a w);
select x.a{y}.b
from x, (select c from z) as y(b);
drop x,w,z;
rollback;
