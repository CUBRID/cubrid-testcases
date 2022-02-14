autocommit off;
create class foo (x int, y int, fs set of foo);
create index i_foo_x_y on foo(x, y);
select *
  from foo f1, table(f1.fs) as t(f2)
 where f2.x = 1 and f2.y = 1;
rollback;
