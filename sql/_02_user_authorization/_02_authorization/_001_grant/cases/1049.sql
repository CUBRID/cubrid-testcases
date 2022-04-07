--+ holdcas on;
--Grant user select on common class
call login('dba') on class db_user;
call add_user('user1') on class db_user;
create class t1( a int );
insert into t1 values(1);
grant select on t1 to user1;
call login('user1') on class db_user;

select * from dba.t1;

call login('dba') on class db_user;
drop class t1;
call drop_user('user1') on class db_user;

--+ holdcas off;
