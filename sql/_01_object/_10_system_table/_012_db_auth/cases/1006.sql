--+ holdcas on;
--Test authorization type:update

call login('dba') on class db_user;
create class test_class(col1 integer, col2 varchar(10));
create class test_class1(col1 integer, col2 varchar(10));
insert into test_class values(999, 'nhn');
insert into test_class1 values(888, 'nhnchina');

create user test_user;
grant update on test_class to test_user;
grant update on test_class1 to test_user;

call login ('test_user') on class db_user;
update dba.test_class set col2='nhnchina' where col1=999;
update dba.test_class1 set col2='nhnkorea' where col1=888;

call login('dba') on class db_user;
select grantor_name, grantee_name, 
       class_name, auth_type 
from   db_auth
where  grantee_name = 'TEST_USER' order by 3;

drop user test_user;
drop class test_class;
drop class test_class1;
--+ holdcas off;
