--+ holdcas on;
autocommit off;
select _db_user into :u from _db_user where name = 'nonexistent_user';
rollback;

--+ holdcas off;
