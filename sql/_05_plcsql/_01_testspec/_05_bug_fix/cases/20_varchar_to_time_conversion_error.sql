--+ server-message on
-- Verifies CBRD-25435
-- Extended test cases for varchar to time/timestamp conversions.
-- Ensures that when AM/PM is appended to time/datetime/timestamp, the conversion
-- does not result in an error (due to problems in compilation).
-- Also ensures that when when the year value is not specified in the
-- default parameter for timestamp, the conversion does not result in an error.

evaluate 'Case 1: Default parameter with time conversion';
create or replace procedure test_time_default (
        a time := '12:32:46'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_time_default();
call test_time_default('12:32:46');
-- Additional test: 24-hour time format
call test_time_default('23:45:59');
 -- Edge case: Midnight in 24-hour format
call test_time_default('00:00:00');

evaluate 'Case 2: Time conversion with variable declaration';
create or replace procedure test_time_variable () as
    a time := '11:32:46';
begin
    DBMS_OUTPUT.put_line(a);
end;

call test_time_variable();

evaluate 'Case 3: Explicit parameterized timestamp conversion (no year)';
create or replace procedure test_timestamp_explicit (
        a timestamp := '07:28 pm 09-30'
) as
begin
    -- remove year from the result (otherwise it will append the current year)
    DBMS_OUTPUT.put_line(DATE_FORMAT(a, '%h:%i:%s %p %m/%d'));
end;

call test_timestamp_explicit('07:28 pm 09-30');
-- Additional test: morning timestamp
call test_timestamp_explicit('10:15 am 12-25');
-- Edge case: one minute before midnight
call test_timestamp_explicit('11:59 pm 12-31');

evaluate 'Case 4: Converting various AM/PM datetime formats';
create or replace procedure test_datetime_varied_formats as
    d datetime := datetime'12:00:00 AM 01/01/0001';
begin
    DBMS_OUTPUT.put_line(d);
end;

-- Default AM time on a specific date
call test_datetime_varied_formats();

evaluate 'Case 5: Midnight and noon edge cases';
create or replace procedure test_midnight_noon (
    d datetime := datetime'12:00:00 PM 01/01/2000'
) as
begin
    DBMS_OUTPUT.put_line(d);
end;

call test_midnight_noon();
-- Midnight
call test_midnight_noon('12:00:00 AM 01/01/2000');
-- Noon
call test_midnight_noon('12:00:00 PM 01/01/2000');

evaluate 'Case 6: Edge case with year extremes';
create or replace procedure test_year_edge (
    d datetime := datetime'12:30:00 AM 12/31/0001'
) as
begin
    DBMS_OUTPUT.put_line(d);
end;

call test_year_edge();
-- Edge case with far future date
call test_year_edge('11:59:59 PM 12/31/9999'); 

evaluate 'Case 7: Mixed time formats without seconds';
create or replace procedure test_time_no_seconds (
        a time := '07:30 PM'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

 -- PM with no seconds
call test_time_no_seconds('07:30 PM');
 -- AM with no seconds
call test_time_no_seconds('11:15 AM');

evaluate 'Case 8: Invalid format handling (error expected)';
create or replace procedure test_invalid_time () as
    a time := '25:61:61';
begin
    DBMS_OUTPUT.put_line(a);
end;

-- Expected to fail due to invalid time format
call test_invalid_time();

evaluate 'Case 9: Handling of default timestamp with seconds and AM/PM';
create or replace procedure test_timestamp_seconds (
        a timestamp := '07:28:15 pm 09-30'
) as
begin
    DBMS_OUTPUT.put_line(DATE_FORMAT(a, '%h:%i:%s %p %m/%d'));
end;

call test_timestamp_seconds();
-- Additional AM timestamp
call test_timestamp_seconds('05:22:10 am 06-15');

evaluate 'Case 10: Extreme values for time';
create or replace procedure test_extreme_time (
    a time := '23:59:59'
) as
begin
    DBMS_OUTPUT.put_line(a);
end;

-- Maximum valid time in 24-hour format
call test_extreme_time();
-- Minimum valid time in 24-hour format
call test_extreme_time('00:00:01');

evaluate 'Cleanup';
drop procedure test_time_default;
drop procedure test_time_variable;
drop procedure test_timestamp_explicit;
drop procedure test_datetime_varied_formats;
drop procedure test_midnight_noon;
drop procedure test_year_edge;
drop procedure test_time_no_seconds;
drop procedure test_invalid_time;
drop procedure test_timestamp_seconds;
drop procedure test_extreme_time;

--+ server-message off

