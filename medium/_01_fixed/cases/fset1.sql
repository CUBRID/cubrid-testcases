autocommit off;
select {1,2}-{2,3} from class faculty1
create class foo (bar set of int);
/* This ought to work */
insert into foo values ({10}+{20});
insert into foo values ({1,2}-{2});
insert into foo values ({1,2}*{2,3});
insert into foo values ({1,0}+{11,12,13,10,14});
select * from foo;
rollback work;
create class ss (s string);
/* This ought to work too */
insert into ss values ('a' + 'b' + 'c');
select * from ss where s like ('a' + 'b' + '_');
rollback work;
create class x (sx set of x);
insert into x(sx) values({null});
rollback work;
create class x (a set_of float);
insert into x values ({1.2, 3.4});
select * from x;
rollback work;
create class foo (dates set of date);
        insert into foo values ({'4/7/56'});
        select * from foo where '4/7/56' in foo.dates;
rollback work;
create class y (a int, sa sequence (int));
insert into y(a,sa) values
 (select count(*) from y, { (select count(*) from y) } )
select * from y;
rollback work;
create class x (a string);
create class y (b string, sx set of x);
insert into x values ('x0') into x0;
insert into x values ('x1') into x1;
insert into y values ('y0', {x0, x1});
select * from y;
rollback work;
create class x (a string);
create class y (b string, sx set of x);
insert into x values ('x0') into x0;
insert into x values ('x1') into x1;
insert into y values ('y0', set{x0, x1});
select * from y;
rollback work;
create class w (s string, i int);
create class x (s string, i int);
create class y (s string, a x, b x);
insert into w values ('w0', 00);
insert into w values ('w1', 10);
insert into w values ('w2', 20);
insert into x values ('x0', 00) to x0;
insert into x values ('x1', 10) to x1;
insert into y values ('y0', x0, null);
insert into y values ('y1', x0, x1);
select y0.s, y1.s, set(select w.i from w where w.i > y0.a.i)
from y y0, y y1
where y0.a.i = y1.a.i

rollback work;
create class x (a int, sx set of x);
insert into x(sx) values ({(insert into x(a) values (10))});
select * from x;
rollback work;
rollback;
