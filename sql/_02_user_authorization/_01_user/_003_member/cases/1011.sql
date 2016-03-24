-- [er]add and drop member by other
autocommit off;

call login('dba','') on class db_user;
create USER user2;
call login('user2','') on class db_user;
create USER user1 groups dba;
call find_user('dba')on class db_user to admin;
call drop_member('user1') on admin;
call login('dba','') on class db_user;

DROP user user1;
DROP user user2;

rollback;

autocommit on;

