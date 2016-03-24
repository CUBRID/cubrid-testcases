autocommit off;
  create class setA(a set int, b set string, c set)
  insert into setA values({1,2}, {'hi'}, {});
  
  select a+b from setA;
  select a-b from setA;
  select a*b from setA;
  select b+a from setA;
  select b-a from setA;
  select b*a from setA;
  select c+b from setA;
  select c-b from setA;
  select c*b from setA;
  select b+c from setA;
  select b-c from setA;
  select b*c from setA;
  select a+c from setA;
  select a-c from setA;
  select a*c from setA;
  select c+a from setA;
  select c-a from setA;
  select c*a from setA;
rollback;
