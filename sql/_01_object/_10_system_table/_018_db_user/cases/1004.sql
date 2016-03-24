--Test system table db_user's attribute:groups

--+ holdcas on;
call login('dba') on class db_user;
create user test_user password 'passwd' groups dba;
create user test_user1 groups test_user;



select name, id, password, direct_groups,groups
from   db_user
where  name = 'TEST_USER1';

drop user test_user;
drop user test_user1;
commit;
--+ holdcas off;
