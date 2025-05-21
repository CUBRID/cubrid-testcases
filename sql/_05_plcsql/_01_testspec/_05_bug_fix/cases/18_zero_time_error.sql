--+ server-message on
-- verified the CBRD-25594

select 'test javasp' from dual;
create or replace function func_ts(t timestamp) return timestamp as
language java name 'SpTest.testTimestamp(java.sql.Timestamp) return java.sql.Timestamp';

create or replace function func_time(t time) return time as
language java name 'SpTest.testTime(java.sql.Time) return java.sql.Time';

create or replace function func_date(t date) return date as
language java name 'SpTest.testDate(java.sql.Date) return java.sql.Date';

create or replace function func_dt(t datetime) return datetime as
language java name 'SpTest.testTimestamp(java.sql.Timestamp) return java.sql.Timestamp';

select func_ts(timestamp'0000-00-00 00:00:00') from dual;
select func_time('00:00:00') from dual;
select func_date('0000-00-00') from dual;
select func_ts(datetime'0000-00-00 00:00:00') from dual;

drop function func_ts;
drop function func_time;
drop function func_date;
drop function func_dt;

evaluate 'test pl/csql';
create or replace procedure proc_ts() as
begin
    dbms_output.put_line(timestamp('0000-00-00 00:00:00.000'));
end;

create or replace procedure proc_time() as
begin
    dbms_output.put_line(time'00:00:00');
end;

create or replace procedure proc_date() as
begin
    dbms_output.put_line(date'0000-00-00');
end;

create or replace procedure proc_dt() as
begin
    dbms_output.put_line(datetime'0000-00-00 00:00:00.000');
end;

--  CBRD-25187
create or replace procedure proc_unix_to_dt as
begin
    dbms_output.put_line(UNIX_TIMESTAMP(TO_DATETIME('0000-00-00 00:00:00.000')));
end;

--  CBRD-25187
create or replace procedure proc_unix_to_date as
begin
    dbms_output.put_line(UNIX_TIMESTAMP(TO_DATE('0000-00-00')));
end;

--  CBRD-25187
create or replace procedure proc_unix_to_ts as
begin
    dbms_output.put_line(UNIX_TIMESTAMP(TIMESTAMP('0000-00-00 00:00:00.000')));
end;

call proc_ts();
call proc_time();
call proc_date();
call proc_dt();
call proc_unix_to_dt();
call proc_unix_to_date();
call proc_unix_to_ts();

drop procedure proc_ts;
drop procedure proc_time;
drop procedure proc_date;
drop procedure proc_dt;
drop procedure proc_unix_to_dt;
drop procedure proc_unix_to_date;
drop procedure proc_unix_to_ts;

--+ server-message off

