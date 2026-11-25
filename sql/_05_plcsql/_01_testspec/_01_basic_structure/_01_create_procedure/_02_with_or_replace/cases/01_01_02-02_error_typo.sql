/**
 *  This test case verifies CBRD-25097: CREATE OR REPLACE PROCEDURE with a typo fails.
 *
 *  Each case writes one keyword of CREATE OR REPLACE PROCEDURE wrong.
 *  A statement that CTP does not take for a routine ends at the first line that ends with a semicolon,
 *  so its rest runs as another statement that fails too.
 *
 *  Coverage:
 *    Case 1:  creator instead of create fails with a syntax error
 *    Case 2:  procedeur instead of procedure fails with a syntax error
 *    Case 3:  to instead of as fails with a syntax error
 *    Case 4:  began instead of begin fails with a syntax error
 *    Case 5:  ends instead of end leaves the body open, so it runs together with the typos
 *             create or replaces, create and replace and return integer in a procedure, and fails
 */

--+ server-message on

evaluate 'Case 1: creator instead of create fails with a syntax error; result = Error:-493';
creator or replace procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

evaluate 'Case 2: procedeur instead of procedure fails with a syntax error; result = Error:-493';
create or replace procedeur t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

evaluate 'Case 3: to instead of as fails with a syntax error; result = Error:-493';
create or replace procedure t(i int) to 
begin
    dbms_output.put_line('i=' || i);
end;

evaluate 'Case 4: began instead of begin fails with a syntax error; result = Error:-493';
create or replace procedure t(i int) as 
began
    dbms_output.put_line('i=' || i);
end;

-- ends does not close the body: the statement of Case 5 runs up to the end line after the return integer typo
evaluate 'Case 5: ends instead of end leaves the body open and the statement fails with the typos after it; result = Error:-1360';
create or replace procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
ends;

create or replaces procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

create and replace procedure t(i int) as 
begin
    dbms_output.put_line('i=' || i);
end;

create or replace procedure t(i int) as return integer begin
    dbms_output.put_line('i=' || i);
end;

-- this end closes the statement of Case 5
end;

-- every case fails, so t does not exist and this drop fails unless a case created t by mistake
drop procedure t;

--+ server-message off

