-- The second result, which according to any rational semantics *must* be a superset of the first result.
autocommit off;

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
select w.s, y.s from w, y where w.i = y.a.i;
select w.s, y.s from w, y where (w.i = y.a.i or w.i = y.b.i);
rollback;
