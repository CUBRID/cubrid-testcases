--+ server-message on

-- Check the grammar of the assignment statement.

CREATE OR REPLACE PROCEDURE t()
AS
    p_class_name string;
BEGIN
    p_class_name = 'db_class';
    EXECUTE IMMEDIATE 'select count(*)  from db_class where class_name = ? ' INTO out_cnt USING p_class_name ;
    put_line('count(*): ' || out_cnt);
END;

CREATE OR REPLACE PROCEDURE t()
AS
    p_class_name string;
BEGIN
    p_class_name == 'db_class';
    EXECUTE IMMEDIATE 'select count(*)  from db_class where class_name = ? ' INTO out_cnt USING p_class_name ;
    put_line('count(*): ' || out_cnt);
END;



--+ server-message off
