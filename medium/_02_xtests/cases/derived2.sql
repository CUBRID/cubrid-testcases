autocommit off;
select name, t.a from public.resort r, table(r.cabins) t(a);
rollback;
