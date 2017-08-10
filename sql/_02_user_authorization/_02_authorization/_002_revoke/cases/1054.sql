--+ holdcas on;
--[er]Grant privilege of select,delete,insert and update using specify attribute(x,y) by dba

call login('dba','') on class db_user;
create class ooo ( x int, y int);
create user user1;

grant update (x, y), select , delete, insert on ooo to user1;

drop user user1;
drop ooo;

--+ holdcas off;
