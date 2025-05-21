--+ server-message on
-- Verified for CBRD-25672
-- error code :
-- Specifying stored functions as default values for tables and stored procedures/functions is not allowed.

create or replace function demo_hello_ret() return varchar as 
begin
    return 'hello cubrid';
end;

create or replace function demo_hello_ret2(a int) return varchar as 
begin
    return 'hello cubrid2';
end;

DROP TABLE IF EXISTS col_def_test;

CREATE TABLE col_def_test
(id INT, def_val VARCHAR DEFAULT demo_hello_ret());

INSERT INTO col_def_test (id) VALUES (1), (2);

SELECT * FROM col_def_test;

DROP TABLE IF EXISTS col_def_test;

CREATE TABLE col_def_test
(id INT, def_val VARCHAR DEFAULT demo_hello_ret2(1));

INSERT INTO col_def_test (id) VALUES (1), (2);

SELECT * FROM col_def_test;

CREATE OR REPLACE PROCEDURE test_var (
    a VARCHAR DEFAULT demo_hello_ret()
) AS
BEGIN
    DBMS_OUTPUT.put_line(a);
END;

CREATE OR REPLACE PROCEDURE test_var (
    a VARCHAR DEFAULT demo_hello_ret2(1)
) AS
BEGIN
    DBMS_OUTPUT.put_line(a);
END;

drop function demo_hello_ret, demo_hello_ret2;
drop procedure test_var;

drop table if exists col_def_test;

--+ server-message off

