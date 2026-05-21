--+ holdcas on;
autocommit off;
select _db_user into :user3 from _db_user where name = 'USER3';
select g.name from _db_user, table(groups) t(g) where _db_user = :user3;
rollback;

--+ holdcas off;
