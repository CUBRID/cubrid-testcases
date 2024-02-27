--+ server-message on

-- Check whether it is possible to create a procedure with the same name as itself within the procedure.
-- It is currently possible, but the development team will fix it.

-- bug
CREATE OR REPLACE PROCEDURE t()
AS
BEGIN
    EXECUTE IMMEDIATE 'create or replace procedure t(s string) as begin  dbms_output.put_line(''s='' || s);  end;';
    dbms_output.put_line('first call t()');
END;
call t();
call t('abcd');

drop procedure t;


--+ server-message off
