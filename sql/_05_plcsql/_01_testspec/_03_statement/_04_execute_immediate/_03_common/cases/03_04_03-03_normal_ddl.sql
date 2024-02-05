--+ server-message on

-- Check whether all DDL statements are executed normally using the EXECUTE IMMEDIATE statement.

CREATE OR REPLACE PROCEDURE t_1()
AS
BEGIN
    EXECUTE IMMEDIATE 'drop table if exists ddl_test' ;
    EXECUTE IMMEDIATE 'create table ddl_test ( col1 integer, col2 string )';
    EXECUTE IMMEDIATE 'insert into ddl_test values(1, ''test_001'' )';
    EXECUTE IMMEDIATE 'insert into ddl_test values(2, ''test_002'' )';
END;
call t_1();
select 'ddl_test create table', a.* from ddl_test a order by a.col1;

CREATE OR REPLACE PROCEDURE t_2()
AS
BEGIN
    EXECUTE IMMEDIATE 'drop table if exists ddl_test_like' ;
    EXECUTE IMMEDIATE 'drop table if exists ddl_test_as' ;
    EXECUTE IMMEDIATE 'create table ddl_test_like like ddl_test' ;
    EXECUTE IMMEDIATE 'create table ddl_test_as as select * from ddl_test';
END;
call t_2();
select 'ddl_test_like', a.* from ddl_test_like a order by a.col1;
select 'ddl_test_as',   a.* from ddl_test_as   a order by a.col1;


CREATE OR REPLACE PROCEDURE t_3()
AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test ADD COLUMN col3 string' ;
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test ADD CONSTRAINT pk_ddl_test PRIMARY KEY(col1)' ;
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test ADD INDEX idx01_ddl_test(col2) ' ;
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test MODIFY col1 integer auto_increment' ;
END;
call t_3();
select 'alter table #1 add column, constraint, index, auto_increment';
show create table ddl_test;


CREATE OR REPLACE PROCEDURE t_4()
AS
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test COMMENT ON COLUMN col1 = ''first column'' ';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test RENAME COLUMN col3 AS col4';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test DROP CONSTRAINT pk_ddl_test';
    EXECUTE IMMEDIATE 'ALTER TABLE ddl_test_like DROP COLUMN col2';
END;
call t_4();
select 'alter table #2 comment, rename column, drop constraint, drop column';
show create table ddl_test;
show create table ddl_test_like;


CREATE OR REPLACE PROCEDURE t_5()
AS
BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW view_ddl_test AS SELECT * FROM ddl_test ORDER BY col1 DESC COMMENT ''view table''';
    EXECUTE IMMEDIATE 'CREATE INDEX ix01_ddl_test_as on ddl_test_as(col2)';
    EXECUTE IMMEDIATE 'CREATE SERIAL seq_test_plcsql  START WITH 10000 INCREMENT BY 2 MAXVALUE 20000';
    EXECUTE IMMEDIATE 'CREATE SERVER srv1(HOST=''localhost'', PORT=33000, DBNAME=demodb, USER=dba, PASSWORD='''' )';
    EXECUTE IMMEDIATE 'CREATE SYNONYM synonym_ddl_test for ddl_test';
END;
call t_5();
select 'ddl_test create view', a.* from view_ddl_test a ;
select 'ddl_test create index', a.* from db_index a where a.index_name ='ix01_ddl_test_as' ;
select 'ddl_test create serial', a.* from db_serial a where a.name='seq_test_plcsql';
select 'ddl_test create server', a.* from db_server a where a.link_name='srv1';
select 'ddl_test create synonym', a.* from db_synonym a where a.synonym_name = 'synonym_ddl_test';


CREATE OR REPLACE PROCEDURE t_6()
AS
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ddl_test, ddl_test_like, ddl_test_as ';
    EXECUTE IMMEDIATE 'DROP VIEW view_ddl_test';                         
    EXECUTE IMMEDIATE 'DROP SERIAL seq_test_plcsql';                     
    EXECUTE IMMEDIATE 'DROP SERVER srv1';                                
    EXECUTE IMMEDIATE 'DROP SYNONYM synonym_ddl_test';                   
END;
call t_6();
select 'ddl_test drop table', a.* from db_class a where a.class_name in ('ddl_test', 'ddl_test_like', 'ddl_test_as');
select 'ddl_test drop view', a.* from db_class a where a.class_name = 'view_ddl_test';
select 'ddl_test drop serial', a.* from db_serial a where a.name = 'seq_test_plcsql';
select 'ddl_test drop server', a.* from db_server a where a.link_name='srv1';
select 'ddl_test drop synonym', a.* from db_synonym a where a.synonym_name = 'synonym_ddl_test';


drop procedure t_1;
drop procedure t_2;
drop procedure t_3;
drop procedure t_4;
drop procedure t_5;
drop procedure t_6;


--+ server-message off
