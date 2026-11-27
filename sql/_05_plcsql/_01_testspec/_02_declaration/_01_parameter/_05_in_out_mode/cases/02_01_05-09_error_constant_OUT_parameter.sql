/**
 *  This test case verifies CBRD-25011 and CBRD-28189: a USING value of EXECUTE IMMEDIATE at an OUT
 *  parameter
 *
 *  The USING clause of EXECUTE IMMEDIATE binds IN values only, and USING OUT is not in the grammar
 *  (CBRD-25011). A USING value that goes to an OUT parameter of a CALL in the dynamic SQL is refused
 *  with a semantic error (CBRD-28189), so the CALL of poo fails and DBMS_OUTPUT prints nothing.
 *
 *  Coverage:
 *    Case 1:  a USING value at an OUT parameter fails the CALL
 */

create or replace procedure p(i OUT int) as
begin
    i := 7;
end;

create or replace procedure poo as
    j int := 3;
begin
    execute immediate 'call p(?)' using  j;
    dbms_output.put_line('j=' || j);
end;

evaluate 'Case 1: a USING value at an OUT parameter fails the CALL';
--+ server-message on
CALL poo();
--+ server-message off

drop procedure p;
drop procedure poo;
