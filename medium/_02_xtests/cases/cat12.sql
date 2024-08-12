autocommit off;
call login('dba', '') on class db_user;
create class foo12;
call add_user('USER12') on class db_user;
grant all on foo12 to USER12;
select * 
from db_auth 
where grantee_name = 'USER12' 
order by object_name, grantor_name, auth_type, is_grantable;
revoke delete on foo12 from USER12;
select * 
from db_auth 
where grantee_name = 'USER12' 
order by object_name, grantor_name, auth_type, is_grantable;
grant delete on foo12 to USER12 with grant option;
select * 
from db_auth 
where grantee_name = 'USER12' 
order by object_name, grantor_name, auth_type, is_grantable;
revoke all on foo12 from USER12;
select * 
from db_auth 
where grantee_name = 'USER12' 
order by object_name, grantor_name, auth_type, is_grantable;
grant all on foo12 to USER12;
call drop_user('USER12') on class db_user;
select * 
from db_auth 
where grantee_name = 'USER12' 
order by object_name, grantor_name, auth_type, is_grantable;
call add_user('USER12_1') on class db_user;
call add_user('USER12_2') on class db_user;
grant select on foo12 to USER12_1;
grant insert, delete on foo12 to USER12_1;
select db_user to u1 
from db_user 
where name = 'USER12_1';
select db_user to u2 
from db_user 
where name = 'USER12_2';
call add_member(u2) on u1;
select * 
from db_auth 
where grantee_name = 'USER12_2' 
order by object_name, grantor_name, auth_type, is_grantable;
call drop_user('USER12_1') on class db_user;
call drop_user('USER12_2') on class db_user;
drop class foo12;
call login('dba', '') on class db_user;
rollback;
