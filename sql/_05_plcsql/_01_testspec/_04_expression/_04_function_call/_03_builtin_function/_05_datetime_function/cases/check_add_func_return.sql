--+ server-message on
-- verified the CBRD-25059

-- adddate
create or replace procedure test_adddate1 as
    a datetime := datetime'2016-3-9 01:02:03.456';
	b datetime := adddate(date(a), 3);
    c varchar(20);
begin
    select typeof(b) into c from dual;
	dbms_output.put_line('adddate 1: ' || b);
    dbms_output.put_line('type: ' || c);
end;

call test_adddate1();

create or replace procedure test_adddate2 as
    a datetime := datetime'2007-12-31 23:59:59.456';
    b datetime := addtime(a, time'1:1:2');
    c varchar(20);
begin
    select typeof(b) into c from dual;
    dbms_output.put_line('adddate 2: ' || b);
    dbms_output.put_line('type: ' || c);
end;

call test_adddate2();


--addtime
create or replace procedure test_time as
    a time := time'01:00:00';
    b time := addtime(a, time'02:00:01');
    c varchar(20);
begin
    select typeof(b) into c from dual;
    dbms_output.put_line('addtime: ' || b);
    dbms_output.put_line('type: ' || c);
end;

call test_time();


--add_months
create or replace procedure test_months as
    a date := date'2023-12-08';
    b date := add_months(date(a), 1);
    c varchar(20);
begin
    select typeof(b) into c from dual;
    dbms_output.put_line('add_months: ' || b);
    dbms_output.put_line('type: ' || c);
end;

call test_months();


drop procedure test_adddate1;
drop procedure test_adddate2;
drop procedure test_time;
drop procedure test_months;


--+ server-message off
