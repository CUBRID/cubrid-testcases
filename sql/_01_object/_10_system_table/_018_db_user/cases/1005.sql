--Test system table db_user's attribute:authorization


--+ holdcas on;
call login('dba') on class db_user;
create class test_class (col1 integer, col2 varchar(10));
insert into test_class values(999, 'nhn');
insert into test_class values(888, 'nhnchina');
create user test_user ;
grant select on test_class to test_user;
grant insert on test_class to test_user;
grant update on test_class to test_user;
grant delete on test_class to test_user;
grant alter on test_class to test_user;
grant index on test_class to test_user;
grant execute on test_class to test_user;




select name, id, password, direct_groups,groups,authorization
from   db_user
where  name = 'TEST_USER';

drop user test_user;
drop class test_class;
commit;
--+ holdcas off;
