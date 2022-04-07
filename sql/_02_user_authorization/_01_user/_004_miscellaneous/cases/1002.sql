--+ holdcas on;
-- [er]create two hash partition tables of size 16 and  one of using primary key of another user's table as foreign key

call login('dba','') on class db_user;
create user user1;
create user user2;

call login('user1','') on class db_user;
create class xoo1( a int);

call login('user2','') on class db_user;
create class xoo2( a int, FOREIGN key(a) references user1.xoo1(a) );


drop user1.xoo1;
drop user2.xoo2;

drop user user1;
drop user user2;

call login('dba','') on class db_user;
drop user1.xoo1;
drop user2.xoo2;

drop user user1;
drop user user2;
--+ holdcas off;
