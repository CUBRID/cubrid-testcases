autocommit off;
--set optimization: level 257
select count(*) from public.med,public.big where med.b=big.b;
rollback;
