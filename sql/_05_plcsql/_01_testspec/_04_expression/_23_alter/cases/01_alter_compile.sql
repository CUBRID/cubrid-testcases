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


evaluate 'drop table & ERROR: Syntax: Unknown class dba.tbl';
drop table tbl;

call test_tbl();

drop PROCEDURE test_tbl;


evaluate 'create t1 & check for %type';
create table t1(col int);

create or replace procedure test_proc(a t1.col%type)
as
begin
    DBMS_OUTPUT.put_line('args value: ' || a);
end;

call test_proc(1);

evaluate 'changed column type on t1.col (int -> char(1))';
alter table t1 modify column col char(1);

evaluate 'before re-compile procedure';
call test_proc('a');
call test_proc(1);


evaluate 'after re-compile procedure';
ALTER procedure test_proc compile;
call test_proc('a');
call test_proc(1);

evaluate 'changed column type on t1.col (char(1) -> int)';
alter table t1 modify column col int;
ALTER procedure test_proc compile;
call test_proc('a');
call test_proc(1);

evaluate 'drop t1';
drop t1;
call test_proc('a');
call test_proc(1);

evaluate 'after re-compile procedure & Error: Failed to get attribute information';
ALTER procedure test_proc compile;
call test_proc('a');
call test_proc(1);

drop procedure test_proc;
--+ server-message off
