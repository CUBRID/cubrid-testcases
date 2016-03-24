-- [er]add member which created by other user
autocommit off;

call login('dba','') on class db_user;
create USER user1;
call login('public','') on class db_user;
call find_user('dba')on class db_user to admin;
call add_member('user1') on admin;
call drop_member('user1') on admin;
call login('dba','') on class db_user;

DROP user user1;

rollback;

autocommit on;
