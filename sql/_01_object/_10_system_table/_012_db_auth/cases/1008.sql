--+ holdcas on;
--Test authorization type:alter

call login('dba') on class db_user;
create class test_class(col1 integer, col2 varchar(10));
create class test_class1(col1 integer, col2 varchar(10));
insert into test_class values(999, 'nhn');
insert into test_class1 values(888, 'nhnchina');

create user test_user;
grant alter on test_class to test_user;
grant alter on test_class1 to test_user;

call login ('test_user') on class db_user;
alter class dba.test_class add column col3 integer;
drop class dba.test_class1;

call login('dba') on class db_user;
select * from test_class;
select grantor_name, grantee_name, 
       class_name, auth_type 
from   db_auth
where  grantee_name = 'TEST_USER' order by 3;

drop user test_user;
drop class test_class;

--+ holdcas off;
