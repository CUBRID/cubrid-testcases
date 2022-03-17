autocommit off;
create class x (a int, b int, c char(16));
create class y (p int, q int, r char(16));
insert into x values (1, 101, 'ksseo');
insert into x select a +   1, b +   1, c from x;
insert into x select a +   2, b +   2, c from x;
insert into x select a +   4, b +   4, c from x;
insert into x select a +   8, b +   8, c from x;
insert into x select a +  16, b +  16, c from x;
insert into x select a +  32, b +  32, c from x;
insert into x select a +  64, b +  64, c from x;
insert into x select a + 128, b + 128, c from x;
insert into x select a + 256, b + 256, c from x;
insert into x select a + 512, b + 512, c from x; -- #1024
insert into y values (1, 201, '__tb__');
insert into y select p +   1, q +   1, r from y;
insert into y select p +   2, q +   2, r from y;
insert into y select p +   4, q +   4, r from y;
insert into y select p +   8, q +   8, r from y;
insert into y select p +  16, q +  16, r from y;
insert into y select p +  32, q +  32, r from y;
insert into y select p +  64, q +  64, r from y;
insert into y select p + 128, q + 128, r from y;
insert into y select p + 256, q + 256, r from y;
insert into y select p + 512, q + 512, r from y; -- #1024
create index i_x_a on x (a);
create index i_y_q on y (q);
--set optimization: level 257;
select X1.a, X1.b 
from X X1, X X2 
where X1.a between 5 and 10 and X1.a = X2.a;
select X.a, Y.q 
from X, Y 
where X.a <= 3 and Y.q <= 203;
select X1.a, X2.b 
from X X1, X X2 
where X1.a < 5 and X2.a < 3;
rollback work;
rollback;
