autocommit off;

call login('dba','') on class db_user;

call add_user('user1','') on class db_user;
call add_user('user2','') on class db_user;

call login('user1','') on class db_user;
CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';

call login('user2','') on class db_user;

create class xoo ( x int, y int);
insert into xoo values(1,2);
insert into xoo values(2,2);
$integer,$3;
insert into xoo values(3,test1(?)) ;
drop xoo;

call login('user1','') on class db_user;
create class xoo ( x int, y int);
insert into xoo values(1,2);
insert into xoo values(2,2);
$integer,$3;
insert into xoo values(3,test1(?)) ;
drop xoo;

call login('dba','') on class db_user;
create class xoo ( x int, y int);
insert into xoo values(1,2);
insert into xoo values(2,2);
$integer,$3;
insert into xoo values(3,test1(?)) ;
drop function test1;
drop xoo;

call login('public','') on class db_user;
CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';

call login('user2','') on class db_user;

create class xoo ( x int, y int);
insert into xoo values(1,2);
insert into xoo values(2,2);
$integer,$3;
insert into xoo values(3,test1(?)) ;
drop xoo;
drop function test1;

call login('dba','') on class db_user;
CREATE  FUNCTION test1(i int) RETURN int as language java name 'SpTest.testInt(int) return int';

call login('user2','') on class db_user;

create class xoo ( x int, y int);
insert into xoo values(1,2);
insert into xoo values(2,2);
$integer,$3;
insert into xoo values(3,test1(?)) ;
drop xoo;
drop function test1;

call login('dba','') on class db_user;
drop xoo;
drop function test1;

rollback;

autocommit on;

