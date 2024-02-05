--+ server-message on

-- Check the EXECUTE IMMEDIATE grammar.

CREATE PROCEDURE collect_athlete_history(new_table VARCHAR)
AS
BEGIN
    EXECUTEs IMMEDIATE 'create table ' || new_table || '( col1 varchar(10), col2 varchar(10) )';
END;

CREATE PROCEDURE collect_athlete_history(name VARCHAR)
AS
BEGIN
    EXECUTE IMMEDIATEs 'create table ' || new_table || '( col1 varchar(10), col2 varchar(10) )';
END;

CREATE PROCEDURE collect_athlete_history(new_table VARCHAR)
AS
BEGIN
    EXECUTE IMMEDIATE 'insert into ' || new_table || ' select * from plcsql_tbl where name = ''name1'''
        USINGs name;
END;


--+ server-message off
