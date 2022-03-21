autocommit off;
call login ('user1', '') on class db_user;
revoke all on joe.kitsch_v from public;
insert into joe.kitsch_v (atom_c)
values ();
call login ('dba', '') on class db_user;
rollback;
