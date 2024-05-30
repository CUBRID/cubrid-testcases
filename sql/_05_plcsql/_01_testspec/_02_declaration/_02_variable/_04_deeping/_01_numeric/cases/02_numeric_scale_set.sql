--+ server-message on
-- Verification for CBRD-24832

create or replace procedure numeric_test(i numeric) as
	n1 numeric (5,3) := i;
begin
	dbms_output.put_line('n1: ' || n1);
end;


select 'success, round 0.4 digit' from dual;
call numeric_test(0.01234567890123456789012345678901234567);
call numeric_test(0.0129);
call numeric_test(12.0129);


select 'fail, precision digit over' from dual;
call numeric_test(123.012);


drop procedure numeric_test;

--+ server-message off
