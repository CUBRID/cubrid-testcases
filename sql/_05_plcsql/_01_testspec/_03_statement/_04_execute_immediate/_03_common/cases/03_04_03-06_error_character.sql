--+ server-message on

-- Check whether it is possible to change the ' character to " or ` in the execute immediate statement.

CREATE OR REPLACE PROCEDURE t()
AS
BEGIN
    EXECUTE IMMEDIATE "create table ttt(col1 integer)";
END;

CREATE OR REPLACE PROCEDURE t()
AS
BEGIN
    EXECUTE IMMEDIATE `create table ttt(col1 integer)`;
END;


--+ server-message off
