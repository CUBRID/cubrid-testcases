autocommit off;
  create class setA(i integer unique, mset2 multiset(integer));
  insert into setA values(12, {1,2});
  
  select {}    + mset2 from setA;
  select mset2 + {}    from setA;
  select {}    * mset2 from setA;
  select mset2 * {}    from setA;
  select {}    - mset2 from setA;
  select mset2 - {}    from setA;
rollback;
