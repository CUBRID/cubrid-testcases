--+ server-message on

-- Check if an error occurs in the error DDL statement written with the EXECUTE IMMEDIATE statement.

CREATE OR REPLACE PROCEDURE t_1()
AS
BEGIN
    EXECUTE IMMEDIATE 'drop tables if exists ddl_test' ;
    EXECUTE IMMEDIATE 'create tables ddl_test ( col1 integer, col2 string )';
    EXECUTE IMMEDIATE 'insert into ddl_test values(1, ''test_001'', 3 )';
    EXECUTE IMMEDIATE 'insert into ddl_test values(2, ''test_002'', 3 )';
END;
call t_1();

CREATE OR REPLACE PROCEDURE t_2()
AS
BEGIN
    EXECUTE IMMEDIATE 'drop table if exists ddl_test_like' ;
    EXECUTE IMMEDIATE 'drop table if exists ddl_test_as' ;
    EXECUTE IMMEDIATE 'create table ddl_test_like likes ddl_test' ;
    EXECUTE IMMEDIATE 'create table ddl_test_as ass select * from ddl_test';
END;
call t_2();


CREATE OR REPLACE PROCEDURE t_3()
AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test ADD COLUMN col3 string' ;
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test ADD CONSTRAINT pk_ddl_test PRIMARY KEY(col1)' ;
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test ADD INDEX idx01_ddl_test(col2) ' ;
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test MODIFY col1 integer auto_increment' ;
END;
call t_3();


CREATE OR REPLACE PROCEDURE t_4()
AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test COMMENTs ON COLUMN col1 = ''first column'' ';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test RENAMEs COLUMN col3 AS col4';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test DROPs CONSTRAINT pk_ddl_test';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test_like DROP COLUMNs col2';
END;
call t_4();


CREATE OR REPLACE PROCEDURE t_5()
AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEWs view_ddl_test AS SELECT * FROM ddl_test ORDER BY col1 DESC COMMENT ''view table''';
    EXECUTE IMMEDIATE 'CREATE INDEXs ix01_ddl_test_as on ddl_test_as(col2)';
    EXECUTE IMMEDIATE 'CREATE SERIALs seq_test_plcsql  START WITH 10000 INCREMENT BY 2 MAXVALUE 20000';
    EXECUTE IMMEDIATE 'CREATE SERVERs srv1(HOST=''localhost'', PORT=33000, DBNAME=demodb, USER=dba, PASSWORD='''' )';
    EXECUTE IMMEDIATE 'CREATE SYNONYMs synonym_ddl_test for ddl_test';
END;
call t_5();


CREATE OR REPLACE PROCEDURE t_6()
AS
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLEs ddl_test, ddl_test_like, ddl_test_as ';
    EXECUTE IMMEDIATE 'DROP VIEWs view_ddl_test';                         
    EXECUTE IMMEDIATE 'DROP SERIALs seq_test_plcsql';                     
    EXECUTE IMMEDIATE 'DROP SERVERs srv1';                                
    EXECUTE IMMEDIATE 'DROP SYNONYMs synonym_ddl_test';                   
END;
call t_6();


drop procedure t_1;
drop procedure t_2;
drop procedure t_3;
drop procedure t_4;
drop procedure t_5;
drop procedure t_6;


--+ server-message off
