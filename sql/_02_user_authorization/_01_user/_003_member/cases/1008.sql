-- add and drop member by dba
autocommit off;

call login('dba','') on class db_user;

create USER user1 groups dba;

call find_user('dba')on class db_user to admin;

call drop_member('user1') on admin;

DROP user user1;

rollback;

autocommit on;

