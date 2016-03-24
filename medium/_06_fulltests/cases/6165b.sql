autocommit off;
--set optimization: level 257
select big into :o1 from big where a = 1000;
select big into :o2 from big where a = 10000;
select 'hello', b1, b1.a, b1.b from big b1, big b2
where b1 = :o1 and b2 = :o2;
rollback;
