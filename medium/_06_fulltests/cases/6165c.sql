autocommit off;
--set optimization: level 257
select big into :o1 from big where a = 1000;
select big into :o2 from big where a = 10000;
select 'hello', b1, b1.a, b1.b, b2, b2.a, b2.b
from big b1, big b2
where b1 in {o1,o2} and b2 in {o1,o2}
order by b1.a, b1.b, b2, b2.a, b2.b;
rollback;
