--+ holdcas on;
--grant a common user privilege on system tables
call login('dba') on class db_user;
call add_user('user1') on class db_user;


grant select on db_class to user1;
call login('user1') on class db_user;

select * from db_class order by 1;

call login('dba') on class db_user;
call drop_user('user1') on class db_user;

--+ holdcas off;
