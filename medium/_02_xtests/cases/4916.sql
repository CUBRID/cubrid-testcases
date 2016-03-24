autocommit off;
call login('dba', '' ) on class db_user;
call add_user('PR4916_U1', '') on class db_user;
call add_user('PR4916_U2', '') on class db_user;
select db_user to u1 from db_user where name = 'PR4916_U1';
select db_user to u2 from db_user where name = 'PR4916_U2';
select db_user to dba from db_user where name = 'DBA';
call add_member(u1) on u2;
call add_member(u1) on dba;
select g.u.name from db_user, table(db_user.groups) as g(u)
  where db_user.name = 'PR4916_U1';
call drop_member(u1) on dba;
select g.u.name from db_user, table(db_user.groups) as g(u)
  where db_user.name = 'PR4916_U1';
rollback work;
call add_user('PR4916_U1', '') on class db_user;
call add_user('PR4916_U2', '') on class db_user;
select db_user to u1 from db_user where name = 'PR4916_U1';
select db_user to u2 from db_user where name = 'PR4916_U2';
select db_user to dba from db_user where name = 'DBA';
call add_member(u1) on dba;
select g.u.name from db_user, table(db_user.groups) as g(u)
  where db_user.name = 'PR4916_U1';
call drop_member(u1) on dba;
select g.u.name from db_user, table(db_user.groups) as g(u)
  where db_user.name = 'PR4916_U1';
rollback work;
call add_user('PR4916_U1', '') on class db_user;
call add_user('PR4916_U2', '') on class db_user;
call add_user('PR4916_U3', '') on class db_user;
call add_user('PR4916_U4', '') on class db_user;
select db_user to u1 from db_user where name = 'PR4916_U1';
select db_user to u2 from db_user where name = 'PR4916_U2';
select db_user to u3 from db_user where name = 'PR4916_U3';
select db_user to u4 from db_user where name = 'PR4916_U4';
select db_user to dba from db_user where name = 'DBA';
call add_member(u1) on u2;
call add_member(u1) on u3;
call add_member(u1) on u4;
call add_member(u1) on dba;
select g.u.name from db_user, table(db_user.groups) as g(u)
  where db_user.name = 'PR4916_U1';
call drop_member(u1) on dba;
select g.u.name from db_user, table(db_user.groups) as g(u)
  where db_user.name = 'PR4916_U1';
call login('dba', '' ) on class db_user;
rollback;
