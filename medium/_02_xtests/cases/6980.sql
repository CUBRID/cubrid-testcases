autocommit off;
call login( 'dba', '' ) on class db_user;
call add_user( 'usr', '' ) on class db_user to usr;
call add_user( 'grp_usr', '' ) on class db_user;
call login ('grp_usr','') on class db_user;
call find_user('grp_usr') on class db_user to grp_usr;
call add_member('usr')on grp_usr;
call login( 'dba', '' ) on class db_user;
rollback;
