--+ holdcas on;
autocommit off;
select db_user into :user3 from db_user where name = 'USER3';
select g.name from db_user, table(groups) t(g) where db_user = :user3;
rollback;

--+ holdcas off;
