--+ server-message on
-- verified the CBRD-25400
-- [bugfix] results of CALL and EVALUATE statement were removed

evaluate 1 into :a;
call login('public', '') on class db_user;

select :a ;
call login('dba', '') on class db_user;

--+ server-message off
