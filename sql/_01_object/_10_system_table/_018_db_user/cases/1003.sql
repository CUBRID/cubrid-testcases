--Test system table db_user's attribute:direct_groups
--+ holdcas on;
call login('dba') on class db_user;
create user test_user password 'passwd' groups dba;


select name, id, password, direct_groups,groups
from   db_user
where  name = 'TEST_USER';

drop user test_user;
commit;
--+ holdcas off;
