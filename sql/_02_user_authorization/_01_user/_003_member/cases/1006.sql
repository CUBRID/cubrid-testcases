-- drop existing member(user) from group other
autocommit off;

call login('dba','') on class db_user;

create USER user1;
create USER user2 groups user1;

call find_user ('user1') on class db_user to admin;

call drop_member('user2') ON admin;

DROP user user1;
DROP user user2;

rollback;

autocommit on;
