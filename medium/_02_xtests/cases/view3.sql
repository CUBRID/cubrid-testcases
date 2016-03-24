autocommit off;
create class x (xint int);
create vclass vx as select xint from x;
create vclass vx1 as select xint from x;
create class y (sx multiset(x, vx, vx1));
rollback;
