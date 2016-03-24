autocommit off;
call login ('user1', '') on class db_user;
revoke all on kitsch_v from public;
insert into kitsch_v (atom_c)
values ();
call login ('dba', '') on class db_user;
rollback;
