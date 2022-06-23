/* Test 4: when user or object does not exist */
call login ('dba') on class db_user;
select * from db_class where is_system_class = upper ('NO');

drop synonym if exists s1;
create synonym s1 for t1;
--err case : no table
select * from s1;

select name from db_user;
drop synonym if exists s1;
--err case : no user
create synonym s2 for u1.t1;

select * from db_synonym;

call login ('dba') on class db_user;
drop synonym if exists s1;
drop synonym if exists s2;

select * from db_synonym;
select * from db_class where is_system_class = upper ('NO');

