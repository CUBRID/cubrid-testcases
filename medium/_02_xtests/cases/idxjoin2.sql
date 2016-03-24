autocommit off;
create class foo (i int, s string, j int, t string, x int);
insert into foo values (1, '1', 10, '10', 100);
insert into foo values (2, '2', 20, '20', 200);
insert into foo values (3, '3', 30, '30', 300);
insert into foo values (4, '4', 40, '40', 400);
insert into foo values (5, '5', 50, '50', 500);
insert into foo values (6, '6', 60, '60', 600);
insert into foo values (7, '70', 70, '70', 700);
insert into foo values (8, '80', 80, '80', 800);
insert into foo values (9, '90', 90, '90', 900);
insert into foo values (10, '100', 10, '100', 1000);
create index i_foo_i_s_j_t on foo(i, s, j, t);
--set optimization: level 257;
select count(*)
  from foo x
 where x.i = 5 and x.s = '5' and x.j < 90 and x.t < '90' and x.x > 0;
select /*+ ORDERED USE_IDX(y) */ count(*)
  from foo x, foo y
 where x.i = y.i and x.s = y.s and x.j = y.j and x.t = y.t and x.x > 0;
select /*+ ORDERED USE_IDX(y) */ count(*)
  from foo x, foo y
 where x.i = y.i and x.s = y.s and x.x > 0
       and y.j < 50 and y.t < '50';
select /*+ ORDERED USE_IDX(y) */ count(*)
  from foo x, foo y
 where x.i = y.i and x.s = y.s and x.j = y.j and x.t = y.t and x.x > 0
       and x.i < 5 and y.s < '5';
select /*+ ORDERED USE_IDX(y) */ count(*)
  from foo x, foo y
 where x.i = y.i and x.j = y.j and x.x > 0
       and y.s < '5' and y.t < '50';
rollback;
