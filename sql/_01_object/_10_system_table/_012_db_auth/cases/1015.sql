--+ holdcas on;
--[er]Some filed is case-sensitive:IS_GRANTABLE

call login('dba') on class db_user;

create class test_class(col1 integer, col2 varchar(10));
insert into test_class values(999,'nhnchina');
insert into test_class values(888,'nhnkorea');
call add_user('test_user') on class db_user;
call add_user('test_user1') on class db_user;
grant select on test_class to test_user with grant option;

call login('test_user') on class db_user;
select * from test_class order by 1 desc;
grant select on test_class to test_user1;

call login('test_user1') on class db_user;
select * from test_class order by 1 desc;
call login('dba') on class db_user;

--Cannot query any record
select grantor_name, grantee_name, 
       class_name, auth_type, is_grantable
from   db_auth
where  is_grantable in ('yes','no');
call drop_user('test_user1') on class db_user;
call drop_user('test_user') on class db_user;
drop class test_class;




--+ holdcas off;
