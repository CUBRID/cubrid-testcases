autocommit off;
select name, t.a from resort r, table(r.cabins) t(a);
rollback;
