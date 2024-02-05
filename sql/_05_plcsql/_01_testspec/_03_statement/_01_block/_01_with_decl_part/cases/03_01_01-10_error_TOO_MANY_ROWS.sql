--+ server-message on

-- Check whether an error occurs when NO_DATA_FOUND and TOO_MANY_ROWS exceptions are not handled when executing the select into statement.

-- bug - An unknown error occurred
CREATE OR REPLACE PROCEDURE t(name VARCHAR)
AS
     c varchar(100);
BEGIN
    SELECT a.class_name INTO c FROM db_class a WHERE a.class_name like '%'||name||'%';
    put_line('class_name ' || c);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        put_line('error: no rows found for class_name ' || name);
        
    WHEN TOO_MANY_ROWS THEN
        put_line('error: more than one rows found for class_name ' || name);
        
END;

call t('db_class');
 

--+ server-message off
