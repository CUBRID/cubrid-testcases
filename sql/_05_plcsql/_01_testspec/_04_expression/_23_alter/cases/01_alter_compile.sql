/**
 *  This test case verifies CBRD-25106: Support ALTER statement for PROCEDURE/FUNCTION on PL/CSQL
 *
 *  ALTER PROCEDURE COMPILE recompiles a stored procedure against the current schema.
 *  Cases 1 to 5 change and drop the table that test_tbl selects from, and Cases 6 to 12
 *  change and drop the table whose column type test_proc takes with %type.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  test_tbl selects col1 of tbl into a variable and prints it
 *    Case 2:  ALTER TABLE CHANGE turns col1 into col2 CHAR(2), as show create table shows
 *    Case 3:  test_tbl, compiled before the change, fails to execute because col1 is gone
 *    Case 4:  as public, ALTER PROCEDURE test_tbl COMPILE fails because public.test_tbl does not exist, as dba it recompiles and test_tbl prints the value again
 *    Case 5:  after drop table tbl, test_tbl fails with Unknown class
 *    Case 6:  test_proc with a parameter of t1.col%type (int) runs
 *    Case 7:  t1.col changes from int to char(1)
 *    Case 8:  before the recompile, test_proc keeps its int parameter, so a string argument fails
 *    Case 9:  after the recompile, test_proc takes char(1) and accepts both arguments
 *    Case 10: after t1.col goes back to int and a recompile, a string argument fails again
 *    Case 11: after drop t1, test_proc still runs with its int parameter
 *    Case 12: a recompile after drop t1 fails, and test_proc keeps its int parameter
 */

--+ server-message on

drop table if exists tbl;
CREATE TABLE tbl (col1 int);
insert into tbl values(11);

CREATE OR REPLACE PROCEDURE test_tbl()
AS
    a int;
BEGIN
    SELECT * INTO a FROM tbl;
	
	DBMS_OUTPUT.put_line('col1 :' || a);
END;

evaluate 'Case 1: test_tbl selects col1 of tbl into a variable and prints it';
call test_tbl();

evaluate 'Case 2: ALTER TABLE CHANGE turns col1 into col2 CHAR(2), as show create table shows';
ALTER TABLE tbl CHANGE col1 col2 CHAR(2);
show create table tbl;

evaluate 'Case 3: test_tbl, compiled before the change, fails to execute because col1 is gone';
call test_tbl();


evaluate 'Case 4: as public, ALTER PROCEDURE test_tbl COMPILE fails because public.test_tbl does not exist, as dba it recompiles and test_tbl prints the value again';
call login('public','') on class db_user;
ALTER procedure test_tbl compile;

call login('dba','') on class db_user;
ALTER procedure test_tbl compile;

call test_tbl();


evaluate 'Case 5: after drop table tbl, test_tbl fails with Unknown class';
drop table tbl;

call test_tbl();

drop PROCEDURE test_tbl;


evaluate 'Case 6: test_proc with a parameter of t1.col%type (int) runs';
drop table if exists t1;
create table t1(col int);

create or replace procedure test_proc(a t1.col%type)
as
begin
    DBMS_OUTPUT.put_line('args value: ' || a);
end;

call test_proc(1);

evaluate 'Case 7: t1.col changes from int to char(1)';
alter table t1 modify column col char(1);

evaluate 'Case 8: before the recompile, test_proc keeps its int parameter, so a string argument fails';
call test_proc('a');
call test_proc(1);


evaluate 'Case 9: after the recompile, test_proc takes char(1) and accepts both arguments';
ALTER procedure test_proc compile;
call test_proc('a');
call test_proc(1);

evaluate 'Case 10: after t1.col goes back to int and a recompile, a string argument fails again';
alter table t1 modify column col int;
ALTER procedure test_proc compile;
call test_proc('a');
call test_proc(1);

evaluate 'Case 11: after drop t1, test_proc still runs with its int parameter';
drop t1;
call test_proc('a');
call test_proc(1);

evaluate 'Case 12: a recompile after drop t1 fails, and test_proc keeps its int parameter';
ALTER procedure test_proc compile;
call test_proc('a');
call test_proc(1);

drop procedure test_proc;
--+ server-message off
