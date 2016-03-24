--+ holdcas on;
--[er]Cannot drop a user who own a trigger;
call login('dba','') on class db_user;
create user user1 password 'a';
call login('user1','a') on class db_user;

-- trigger wihout a table in order to differentiate between:
-- cannot drop user because of class (not the purpose of this test)
-- cannot drop user because of trigger 
create trigger tr1
before commit
execute print 'insert a new record';

call login('dba','') on class db_user;
-- error : cannot drop a user which has trigger 
call drop_user('user1') on class db_user;

-- login as user1 and drop trigger
call login('user1','a') on class db_user;
drop trigger tr1;

-- re-login as dba and drop user1
call login('dba','') on class db_user;
call drop_user('user1') on class db_user;


--+ holdcas off;
