--+ holdcas on;
--[er]Grant privilege of select and update using specify attribute(x,y) for update by dba

call login('dba','') on class db_user;
create class ooo ( x int, y int);
create user user1;

grant select,  update (x, y) on ooo to user1;

drop user user1;
drop ooo;

--+ holdcas off;
