autocommit off;
create class foo (i int, j int, k int);
insert into foo values (1, 1, 1);
create index i_foo_i on foo(i);
create index i_foo_j on foo(j);
create index i_foo_k on foo(k);
--set optimization: cost 'iscan' 0;
--set optimization: level 257;
select count(*)
  from foo x, foo y, foo z
 where x.i = y.i
   and y.i = z.i
   and x.i < 2;
rollback work;
create class foo (i0 int, i1 int,
		  j0 int, j1 int,
		  k0 int, k1 int);
insert into foo values (1, 1, 2, 2, 3, 3);
create index i_foo_i0_i1 on foo(i0, i1);
create index i_foo_j0_j1 on foo(j0, j1);
create index i_foo_k0_k1 on foo(k0, k1);
--set optimization: cost 'iscan' 0;
--set optimization: level 257;
select count(*)
  from foo x, foo y, foo z
 where x.i0 = y.i0 and x.i1 = y.i1
   and y.i0 = z.i0 and y.i1 = z.i1
   and x.i0 < 2;
rollback;
