--+ holdcas on;
autocommit off;
--set optimization: level 257
select big into :o1 from public.big where a = 1000;
alter public.big add class attribute kind public.big;
update class public.big set kind = :o1;
evaluate class [public.big] into :c;
select kind, kind.a, kind.b from class public.big x where x = :c;
rollback;

--+ holdcas off;
