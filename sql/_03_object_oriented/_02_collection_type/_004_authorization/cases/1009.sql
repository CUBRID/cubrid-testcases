--+ holdcas on;
--Test attribute direct_group of db_user
call login('dba') on class db_user;
call add_member('u1') on class db_user to dba;

drop user g1;
drop user u1;
drop user u2;
drop user u3;
--+ holdcas off;
