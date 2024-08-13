--+ server-message on

-- Check whether it is possible to drop a procedure with the same name as itself within the procedure.
-- It is currently possible, but the development team will fix it.

-- bug
CREATE OR REPLACE PROCEDURE t()
AS
BEGIN
    EXECUTE IMMEDIATE 'drop procedure t';
    dbms_output.put_line('first call t()');
END;

select 'before', a.sp_name, a.pkg_name, a.sp_type, a.return_type, a.arg_count, a.lang, a.authid, a.owner, a.comment from db_stored_procedure a where a.sp_name='t';
call t();

select 'after', a.sp_name, a.pkg_name, a.sp_type, a.return_type, a.arg_count, a.lang, a.authid, a.owner, a.comment from db_stored_procedure a where a.sp_name='t';

drop procedure t;


--+ server-message off
