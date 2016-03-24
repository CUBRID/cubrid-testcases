autocommit off;
create class X (xstr string);
create class Y as subclass of X (ystr string);
create class Z as subclass of Y (zstr string);
insert into X values ('x') into :x;
insert into X values ('gack');
insert into Y values ('y', 'y') into :y;
insert into Z values ('z', 'z', 'z') into :z;
create class S (xs sequence of X);
insert into S values ({:x, :y, :z});
select xs into :xs from S order by 1;
select x, x{XX}.xstr from table(:xs) as t(x), all X XX order by 2;
select x, x.xstr from table((select xs from S)) as t(x) order by 2;
select x, x.xstr from S, table(xs) as t(x) order by 2;
select x, x.xstr from table(:xs) as t(x)  order by 2;

rollback;
