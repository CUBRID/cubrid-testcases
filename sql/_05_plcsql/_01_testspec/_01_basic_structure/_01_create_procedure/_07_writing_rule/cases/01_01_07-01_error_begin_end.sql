/**
 *  This test case verifies CBRD-25097: a procedure body with a wrong BEGIN fails.
 *
 *  A wrong END is not checked here: the statement would not end.
 *
 *  Coverage:
 *    Case 1:  a body without BEGIN fails with a syntax error
 *    Case 2:  a semicolon right after BEGIN fails to compile
 */

--+ server-message on

evaluate 'Case 1: a body without BEGIN fails with a syntax error; result = Error:-493';
create procedure t(i int) as 

    dbms_output.put_line('i=' || i);
end;

evaluate 'Case 2: a semicolon right after BEGIN fails to compile; result = Error:-1360';
create procedure t(i int) as 
begin;
    dbms_output.put_line('i=' || i);
end;


--+ server-message off

