autocommit off;
 create class x (xint int);
 create class subx as subclass of x;
 create class y (yint int, to_x x);
 insert into subx values (4) into sx1;
 insert into y values (1, sx1);
rollback work;
rollback;
