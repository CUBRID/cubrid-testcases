--+ holdcas on;
autocommit off;
--set optimization: level 257
select big into :o1 from public.big where a = 1000;
select big into :o2 from public.big where a = 10000;
alter public.big add attribute me public.big;
update object :o1 set me = :o1;
update object :o2 set me = :o2;
select 'hi', b1, b1.b, b1.me.a, b1.me.me.b, b1.me.me.me.a,
       'ho', b2, b2.b, b2.me.a, b2.me.me.b, b2.me.me.me.a
from public.big b1, public.big b2
where b1 = o1 and b2 = o2 order by 1,2,3,4,5;
select 'hi', b1, b1.b, b1.me.a, b1.me.me.b, b1.me.me.me.a,
       'ho', b2, b2.b, b2.me.a, b2.me.me.b, b2.me.me.me.a
from public.big b1, public.big b2
where b1 in {o1,o2} and b2 in {o1,o2} order by 1,2,3,4,5;
rollback;

--+ holdcas off;
