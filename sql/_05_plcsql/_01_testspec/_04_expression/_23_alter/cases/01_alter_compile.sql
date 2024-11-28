--+ server-message on
-- verified the CBRD-25106

CREATE TABLE tbl (col1 int);
insert into tbl values(11);

CREATE OR REPLACE PROCEDURE test_tbl()
AS
    a int;
BEGIN
    SELECT * INTO a FROM tbl;
	
	DBMS_OUTPUT.put_line('col1 :' || a);
END;

call test_tbl();

evaluate 'alter table & print the "show create table" result';
ALTER TABLE tbl CHANGE col1 col2 CHAR(2);
show create table tbl;

evaluate 'ERROR: Stored procedure execute error';
call test_tbl();


evaluate 'ERROR: Operation can only be performed by the DBA or a DBA group member';
call login('public','') on class db_user;
ALTER procedure test_tbl compile;

call login('dba','') on class db_user;
ALTER procedure test_tbl compile;

call test_tbl();

drop table tbl;
drop PROCEDURE test_tbl;

--+ server-message off
