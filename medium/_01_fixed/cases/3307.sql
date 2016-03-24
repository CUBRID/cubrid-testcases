autocommit off;
    create class foo(a1 int);
      create class foo1(b1 foo);
      create class foo2(c1 foo1);
      select c1.b1.a1
      from foo2
      group by c1.b1.a1 ;
drop foo, foo1, foo2;
rollback;
