--+ server-message on
-- verified the CBRD-25059

-- adddate
create or replace procedure test_adddate1 as
    a datetime := datetime'2016-3-9 01:02:03.456';
	b datetime := adddate(date(a), 3);
begin
	dbms_output.put_line('adddate 1: ' || b);
end;

call test_adddate1();

create or replace procedure test_adddate2 as
    a datetime := datetime'2007-02-01 23:59:59.456';
    b datetime := addtime(a, time'1:1:2');
begin
    dbms_output.put_line('adddate 2: ' || b);
end;

call test_adddate2();


--addtime
create or replace procedure test_time as
    a time := time'01:00:00';
    b time := addtime(a, time'02:00:01');
begin
    dbms_output.put_line('addtime: ' || b);
end;

call test_time();


--add_months
create or replace procedure test_months as
    a date := date'2023-12-08';
    b date := add_months(date(a), 1);
begin
    dbms_output.put_line('add_months: ' || b);
end;

call test_months();


drop procedure test_adddate1;
drop procedure test_adddate2;
drop procedure test_time;
drop procedure test_months;


--+ server-message off
