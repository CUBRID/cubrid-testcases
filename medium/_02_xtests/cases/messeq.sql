autocommit off;
--set optimization: level 257;
select a2
  from messea a, messeb b
 where a.a1 = b.b1
   and a.a2 = b.b2
rollback;
