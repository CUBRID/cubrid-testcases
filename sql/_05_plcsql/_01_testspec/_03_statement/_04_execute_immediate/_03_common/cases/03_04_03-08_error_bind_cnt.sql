--+ server-message on

-- Check whether an error occurs if the number of host variable positions (question marks) in the execution string of the execute immediate statement and the number of values in the using clause are different.

CREATE OR REPLACE PROCEDURE t()
AS
    out_cnt integer;
BEGIN
    EXECUTE IMMEDIATE 'select count(*)  from db_class where class_name = ? ' INTO out_cnt USING 'db_class', 'db_server' ;
    put_line('count(*): ' || out_cnt);
END;
call t();

CREATE OR REPLACE PROCEDURE t()
AS
    out_cnt integer;
BEGIN
    EXECUTE IMMEDIATE 'select count(*)  from db_class where class_name = ? ' INTO out_cnt ;
    put_line('count(*): ' || out_cnt);
END;
call t();

drop procedure t;

--+ server-message off
