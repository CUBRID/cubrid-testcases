--+ holdcas on;
-- [er] create user by dba in number
call login('dba','') on class db_user;
create user 121 password 'a';
DROP user 121;

--+ holdcas off;
