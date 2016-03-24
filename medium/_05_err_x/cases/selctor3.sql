autocommit off;
create class y (b int);
create class x (a object);
create class z (a1 object);
select x.a{y}.b, z.a1{y}.b
from x, y, z;
drop x,y,z;
rollback;
