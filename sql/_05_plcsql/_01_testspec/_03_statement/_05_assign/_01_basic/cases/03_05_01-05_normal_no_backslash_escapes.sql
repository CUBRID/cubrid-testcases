--+ server-message on

-- Check whether it is processed according to the writing rules in the manual.
-- no_backslash_escapes Regardless of the configuration parameter value, the backslash character is not used as an escape character.

CREATE OR REPLACE PROCEDURE t()
AS
    tmp_str string;
BEGIN
    EXECUTE IMMEDIATE 'SELECT ''A''||CHR(10)||CHR(13)||''B'' FROM DUAL' INTO tmp_str ;
    put_line('CHR(10)||CHR(13) ==> ' || tmp_str);

    EXECUTE IMMEDIATE 'SELECT ''\n''||''B'' FROM DUAL' INTO tmp_str ;
    put_line(' \n || B ==> ' || tmp_str);
END;

set system parameters 'no_backslash_escapes=n';
call t();

set system parameters 'no_backslash_escapes=y';
call t();

drop procedure t;


--+ server-message off
