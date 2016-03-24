-- [er]add non-exisiting member(user) to group
autocommit off;

call login('dba','') on class db_user;

call add_user ('administration', '') on class db_user to admin;

call add_member('user1') ON admin;

DROP user administration;
DROP user user1;

rollback;

autocommit on;

