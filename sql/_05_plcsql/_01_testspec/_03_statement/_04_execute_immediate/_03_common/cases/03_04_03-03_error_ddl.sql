/**
 *  This test case verifies CBRD-25097: PL/CSQL EXECUTE IMMEDIATE with a wrong DDL
 *
 *  Each procedure runs misspelled DDL statements with EXECUTE IMMEDIATE.
 *  The procedures compile, and each call fails with a syntax error at its first statement,
 *  so no table, view, serial, server or synonym is created.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  t_1 fails at DROP TABLES IF EXISTS with a syntax error
 *    Case 2:  t_2 fails at CREATE TABLE LIKES with a syntax error
 *    Case 3:  t_3 fails at ALTER TABLES with a syntax error
 *    Case 4:  t_4 fails at ALTER TABLE COMMENTS with a syntax error
 *    Case 5:  t_5 fails at CREATE OR REPLACE VIEWS with a syntax error
 *    Case 6:  t_6 fails at DROP TABLES with a syntax error
 */

--+ server-message on


evaluate 'Case 1: t_1 fails at DROP TABLES IF EXISTS with a syntax error';
CREATE OR REPLACE PROCEDURE t_1()
AS
BEGIN
    EXECUTE IMMEDIATE 'drop tables if exists ddl_test' ;
    EXECUTE IMMEDIATE 'create tables ddl_test ( col1 integer, col2 string )';
    EXECUTE IMMEDIATE 'insert into ddl_test values(1, ''test_001'', 3 )';
    EXECUTE IMMEDIATE 'insert into ddl_test values(2, ''test_002'', 3 )';
END;
call t_1();

evaluate 'Case 2: t_2 fails at CREATE TABLE LIKES with a syntax error';
CREATE OR REPLACE PROCEDURE t_2()
AS
BEGIN
    EXECUTE IMMEDIATE 'drop table if exists ddl_test_like' ;
    EXECUTE IMMEDIATE 'drop table if exists ddl_test_as' ;
    EXECUTE IMMEDIATE 'create table ddl_test_like likes ddl_test' ;
    EXECUTE IMMEDIATE 'create table ddl_test_as ass select * from ddl_test';
END;
call t_2();


evaluate 'Case 3: t_3 fails at ALTER TABLES with a syntax error';
CREATE OR REPLACE PROCEDURE t_3()
AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test ADD COLUMN col3 string' ;
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test ADD CONSTRAINT pk_ddl_test PRIMARY KEY(col1)' ;
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test ADD INDEX idx01_ddl_test(col2) ' ;
    EXECUTE IMMEDIATE 'ALTER TABLEs ddl_test MODIFY col1 integer auto_increment' ;
END;
call t_3();


evaluate 'Case 4: t_4 fails at ALTER TABLE COMMENTS with a syntax error';
CREATE OR REPLACE PROCEDURE t_4()
AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test COMMENTs ON COLUMN col1 = ''first column'' ';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test RENAMEs COLUMN col3 AS col4';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test DROPs CONSTRAINT pk_ddl_test';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test_like DROP COLUMNs col2';
END;
call t_4();


evaluate 'Case 5: t_5 fails at CREATE OR REPLACE VIEWS with a syntax error';
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


evaluate 'Case 6: t_6 fails at DROP TABLES with a syntax error';
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
