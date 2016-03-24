autocommit off;
  create class foo1( a int);
  create class foo2 under foo1;
  create class bar1 (a int, b int);
  create class bar2 under bar1;
  insert into foo2 values (1);
  insert into foo2 values (1);
  insert into bar2 values (1, 1);
  insert into bar2 values (1, 1);
 
  alter class foo1 add unique(a);
  select * from foo2;
  select * from bar2;
  
  select * from foo2;
  select * from bar2;
  drop class foo1;
  drop class foo2;
  drop class bar1;
  drop class bar2;
 
rollback;
