--+ holdcas on;
--set optimization: level 257
select big into :o1 from public.big where a = 1000;
select big into :o2 from public.big where a = 10000;
select 'hello', b1, b1.a, b1.b from public.big b1, public.big b2
where b1 = :o1 and b2 = :o2;

--+ holdcas off;
