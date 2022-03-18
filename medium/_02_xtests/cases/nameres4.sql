autocommit off;
select name, r.has_view_of from public.resort, table(rooms) t(r);
select name, t.r.has_view_of from public.resort, table(rooms) t(r);
rollback;
