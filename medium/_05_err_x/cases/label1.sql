--+ holdcas on;
autocommit off;
select db_user into :u from db_user where name = 'nonexistent_user'
rollback;

--+ holdcas off;
