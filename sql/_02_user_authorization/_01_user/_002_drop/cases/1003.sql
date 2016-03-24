--+ holdcas on;
-- [er]create user by other user and then drop it
call login('public','') on class db_user;
create user user1 password 'a';

call login('user1','a') on class db_user;

CREATE USER company; 


DROP USER user1;

DROP USER company;

call login('dba','') on class db_user;

--+ holdcas off;
