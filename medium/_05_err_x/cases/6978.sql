autocommit off;
call login( 'dba', '' ) on class db_user;
 
call find_user( 'dba' ) on class db_user to dba;
call add_user( 'mem_dba', '' ) on class db_user;
call add_member( 'mem_dba' ) on dba;
call add_user( 'usr', '' ) on class db_user to usr;
call login ('mem_dba','') on class db_user;
call drop_user ('usr') on class db_user;
call login ('usr','') on class db_user;
call login('dba', '') on class db_user;
rollback;
