autocommit off;
  create class ffoo1 (a int);
  create class ffoo2 under ffoo1;
  create class bar1 (a int, b int);
  create class bar2 under bar1;
  insert into ffoo2 values (1);
  insert into ffoo2 values (1);
  insert into bar2 values (1, 1);
  insert into bar2 values (1, 1);
 
  alter class ffoo1 add unique(a);
  select * from ffoo2;
  select * from bar2;
  commit work;
  select * from ffoo2;
  select * from bar2;
  drop class ffoo1;
  drop class ffoo2;
  drop class bar1;
  drop class bar2;
 
  commit work;
rollback;
