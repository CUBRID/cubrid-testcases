autocommit off;
create class foo_c ( a inT);
create class foo1_c(b1 set(foo_c));
create vclass foo(c1 int) as select a1 from foo_c;
create vclass foo1(d1 set(foo)) as select b1 from foo1_c;
create vclass vfoo (e1 set(foo)) as select d1 from foo1;
select x.c1     from vfoo, table(e1) t(x) ;
rollback;
