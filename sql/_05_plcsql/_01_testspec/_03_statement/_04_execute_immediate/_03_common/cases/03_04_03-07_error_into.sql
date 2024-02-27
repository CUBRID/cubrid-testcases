--+ server-message on

-- Check whether an error occurs if you write an expression in place of the OUT or IN OUT value of the execute immediate statement.

-- bug - error message
CREATE OR REPLACE PROCEDURE t(param varchar)
AS
    out_id integer;
    out_name string;
BEGIN
    EXECUTE IMMEDIATE 'select id, name  from plcsql_tbl where name = ? ' INTO out_id+out_id, out_name USING param   ;
    put_line('id: ' || out_id || ' name: ' || out_name);
END;


--+ server-message off
