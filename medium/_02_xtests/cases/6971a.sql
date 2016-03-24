autocommit off;
rollback;
create class baz (zn int);
create class bar (bn int);
create class foo (fn int, fb bar);
alter class foo add method class set_cost(string, string) function qo_set_cost;
insert into baz values (200);
insert into baz values (NULL);
insert into bar values (1) to :b1;
insert into bar values (2) to :b2;
insert into foo values (10, :b1);
insert into foo values (20, :b2);
insert into foo values (30, NULL);
update statistics on baz, bar, foo;
commit;
--set optimization: level 257;
call set_cost('follow', 'i') on class foo;
call set_cost('nl-join', 'i') on class foo;
call set_cost('m-join', '0') on class foo;
select /*+ recompile use_merge */ fn, fb.bn
  from foo;
select /*+ recompile use_merge */ fn, fb.bn, zn
  from foo, baz;
select fn, fb.bn, zn
  from foo, baz
 where fb is null or fb.bn is null;
select /*+ recompile use_merge */ fn, fb.bn, zn
  from foo, baz
 where fb is null or fb.bn is null or zn is null;
drop class baz, bar, foo;
commit;
rollback;
