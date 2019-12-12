--+ holdcas on;
--[er]Revoke privilege of update using specify attribute(x,y) by dba

call login('dba','') on class db_user;
create class ooo ( x int, y int);
create user user1;

grant update on ooo to user1;
revoke update (x, y) on ooo from user1;
revoke update on ooo from user1;

drop user user1;
drop ooo;

--+ holdcas off;
