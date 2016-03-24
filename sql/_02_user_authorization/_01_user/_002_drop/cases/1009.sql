--+ holdcas on;
-- create user by other dba and then drop it

call login('dba','') on class db_user;

create user USER1 password 'a' GROUPs dba;

call login('USER1','a') on class db_user;


create user USER2;

call login('dba','') on class db_user;


DROP USER USER1;
DROP USER USER2;

--+ holdcas off;
