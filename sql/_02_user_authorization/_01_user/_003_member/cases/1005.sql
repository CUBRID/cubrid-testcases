-- drop existing member(user) from group dba
autocommit off;

call login('dba','') on class db_user;

call find_user ('dba') on class db_user to admin;

create USER user1 groups dba;

call drop_member('user1') ON admin;

DROP user user1;
rollback;

autocommit on;

