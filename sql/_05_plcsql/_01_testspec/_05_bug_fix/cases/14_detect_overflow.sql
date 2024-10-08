--+ server-message on
-- verified the CBRD-25373

evaluate 'undersigned smallint';
create or replace procedure under_sint_minus()
as
    under_sint smallint := -32768;
    under_int int := 	-2147483648;
    under_bint bigint := 
-9223372036854775808;
    over_sint smallint := 32767;
    over_int int := 2147483647;
    over_bint bigint := 9223372036854775807;
begin
    dbms_output.put_line('-32768 - 1');
    under_sint := under_sint - 1;
end;
call under_sint_minus();
drop procedure under_sint_minus;

create or replace procedure under_sint_plus()
as
    under_sint smallint := -32768;
begin
    dbms_output.put_line('-32768 + (-1)');
    under_sint := under_sint + (- 1);
end;
call under_sint_plus();
drop procedure under_sint_plus;

create or replace procedure under_sint_times()
as
    under_sint smallint := -32768;
begin
    dbms_output.put_line('-32768 * 2');
    under_sint := under_sint * 2;
end;
call under_sint_times();
drop procedure under_sint_times;

create or replace procedure under_sint_divide()
as
    under_sint smallint := 0;
begin
    dbms_output.put_line('-65538 / 2');
    under_sint := -65538 / 2;
end;
call under_sint_divide();
drop procedure under_sint_divide;



evaluate 'undersigned int';
create or replace procedure under_int_minus()
as
    under_int int := -2147483648;
begin
    dbms_output.put_line('-2147483648 - 1');
    under_int := under_int - 1;
end;
call under_int_minus();
drop procedure under_int_minus;

create or replace procedure under_int_plus()
as
    under_int int := -2147483648;
begin
    dbms_output.put_line('-2147483648 + (-1)');
    under_int := under_int + (- 1);
end;
call under_int_plus();
drop procedure under_int_plus;

create or replace procedure under_int_times()
as
    under_int int := -2147483648;
begin
    dbms_output.put_line('-2147483648 * 2');
    under_int := under_int * 2;
end;
call under_int_times();
drop procedure under_int_times;

create or replace procedure under_int_divide()
as
    under_int int := 0;
begin
    dbms_output.put_line('-4294967298 / 2');
    under_int := -4294967298 / 2;
end;
call under_int_divide();
drop procedure under_int_divide;



evaluate ' undersigned bigint';
create or replace procedure under_bint_minus()
as
    under_bint bigint := -9223372036854775808;
begin
    dbms_output.put_line('-9223372036854775808 - 1');
    under_bint := under_bint - 1;
end;
call under_bint_minus();
drop procedure under_bint_minus;

create or replace procedure under_bint_plus()
as
    under_bint bigint := -9223372036854775808;
begin
    dbms_output.put_line('-9223372036854775808 + (-1)');
    under_bint := under_bint + (- 1);
end;
call under_bint_plus();
drop procedure under_bint_plus;

create or replace procedure under_bint_times()
as
    under_bint bigint := -9223372036854775808;
begin
    dbms_output.put_line('-9223372036854775808 * 2');
    under_bint := under_bint * 2;
end;
call under_bint_times();
drop procedure under_bint_times;

create or replace procedure under_bint_divide()
as
    under_bint bigint := 0;
begin
    dbms_output.put_line('-18446744073709551618 / 2');
    under_bint := -18446744073709551618 / 2;
end;
call under_bint_divide();
drop procedure under_bint_divide;



evaluate 'smallint';
create or replace procedure over_sint_minus()
as
    over_sint smallint := 0;
begin
    dbms_output.put_line('32769 - 1');
    over_sint := 32769 - 1;
end;
call over_sint_minus();
drop procedure over_sint_minus;

create or replace procedure over_sint_plus()
as
    over_sint smallint := 32767;
begin
    dbms_output.put_line('32767 + 1');
    over_sint := over_sint + 1;
end;
call over_sint_plus();
drop procedure over_sint_plus;

create or replace procedure over_sint_times()
as
    over_sint smallint := 32767;
begin
    dbms_output.put_line('32767 * 2');
    over_sint := over_sint * 2;
end;
call over_sint_times();
drop procedure over_sint_times;

create or replace procedure over_sint_divide()
as
    over_sint smallint := 0;
begin
    dbms_output.put_line('65538 / 2');
    over_sint := 65538 / 2;
end;
call over_sint_divide();
drop procedure over_sint_divide;



evaluate 'int';
create or replace procedure over_int_minus()
as
    over_int int := 0;
begin
    dbms_output.put_line('2147483649 - 1');
    over_int := 2147483649 - 1;
end;
call over_int_minus();
drop procedure over_int_minus;

create or replace procedure over_int_plus()
as
    over_int int := 2147483647;
begin
    dbms_output.put_line('2147483647 + 1');
    over_int := over_int + 1;
end;
call over_int_plus();
drop procedure over_int_plus;

create or replace procedure over_int_times()
as
    over_int int := 2147483647;
begin
    dbms_output.put_line('2147483647 * 2');
    over_int := over_int * 2;
end;
call over_int_times();
drop procedure over_int_times;

create or replace procedure over_int_divide()
as
    over_int int := 0;
begin
    dbms_output.put_line('4294967296 / 2');
    over_int := 4294967296 / 2;
end;
call over_int_divide();
drop procedure over_int_divide;



evaluate 'bigint';
create or replace procedure over_bint_minus()
as
    over_bint bigint := 0;
begin
    dbms_output.put_line('9223372036854775809 - 1');
    over_bint := 9223372036854775809 - 1;
end;
call over_bint_minus();
drop procedure over_bint_minus;

create or replace procedure over_bint_plus()
as
    over_bint bigint := 9223372036854775807;
begin
    dbms_output.put_line('9223372036854775807 + 1');
    over_bint := over_bint + 1;
end;
call over_bint_plus();
drop procedure over_bint_plus;

create or replace procedure over_bint_times()
as
    over_bint bigint := 9223372036854775807;
begin
    dbms_output.put_line('9223372036854775807 * 2');
    over_bint := over_bint * 2;
end;
call over_bint_times();
drop procedure over_bint_times;

create or replace procedure over_bint_divide()
as
    over_bint bigint := 0;
begin
    dbms_output.put_line('18446744073709551619 / 2');
    over_bint := 18446744073709551619 / 2;
end;
call over_bint_divide();
drop procedure over_bint_divide;

--+ server-message off