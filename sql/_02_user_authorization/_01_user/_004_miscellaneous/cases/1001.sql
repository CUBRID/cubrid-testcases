--+ holdcas on;
-- [er] drop _db_serial,this is an error because of authority

drop _db_serial;

call login('dba','') on class db_user;

drop _db_serial;

call login('public','') on class db_user;

call login('dba', '') on class db_user;


--+ holdcas off;
