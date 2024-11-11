--+ server-message on
-- verified the CBRD-25185
-- This verifies that the built-in function call expression ASCII(53) no longer causes a runtime exception and that the db_ascii() function now supports number types internally.

create or replace procedure poo as
begin
    dbms_output.put_line(ASCII(53));
end;

call poo();

prepare st from 'select ASCII(?)';
execute st using 53;
execute st using DATE'2008-10-31';
execute st using TIME'00:00:00';
execute st using TIMESTAMP'2010-10-31 01:15:45';
execute st using DATETIME'2008-10-31 13:15:45';
execute st using datetimetz'10/15/1986 5:45:15.135 am +02:30:20';
execute st using datetimetz'10/15/1986 5:45:15.135 am +02:30';
execute st using datetimetz'10/15/1986 5:45:15.135 am +02';
execute st using datetimeltz'10/15/1986 5:45:15.135 am Europe/Bucharest';
execute st using datetimetz'2001-10-11 02:03:04 AM Europe/Bucharest EEST';
execute st using timestampltz'10/15/1986 5:45:15 am Europe/Bucharest';
execute st using timestamptz'10/15/1986 5:45:15 am Europe/Bucharest';

drop procedure poo;
drop prepare st;

--+ server-message off

