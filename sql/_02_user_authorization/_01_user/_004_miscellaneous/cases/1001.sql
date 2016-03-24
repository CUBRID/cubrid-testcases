--+ holdcas on;
-- [er] drop db_serial,this is an error because of authority

drop db_serial;

call login('dba','') on class db_user;

drop db_serial;

call login('public','') on class db_user;

call login('dba', '') on class db_user;


--+ holdcas off;
