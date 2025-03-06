--+ server-message on
-- This test verifies the following issue: CBRD-25944
-- Specifying a user-defined variable as the first argument of time_format() versus directly specifying the same value
-- returns consistent results for various datetime values (datetime, datetimeltz, datetimetz)

set time zone 'America/Sao_Paulo';

prepare st from 'select time_format(?, ?)';
set @v1=datetime'2025-12-31 22:30:45.999';
set @v2=datetimeltz'2025-12-31 22:30:45.999';
set @v3=datetimeltz'2025-12-31 22:30:45.999 America/Sao_Paulo';
set @v4=datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo';

select time_format(datetime'2025-12-31 22:30:45.999', '%TZR %TZD %TZH %TZM'); 
execute st using datetime'2025-12-31 22:30:45.999', '%TZR %TZD %TZH %TZM'; 
select time_format(@v1, '%TZR %TZD %TZH %TZM'); 
execute st using @v1, '%TZR %TZD %TZH %TZM';

select time_format(datetimeltz'2025-12-31 22:30:45.999', '%TZR %TZD %TZH %TZM'); 
execute st using datetimeltz'2025-12-31 22:30:45.999', '%TZR %TZD %TZH %TZM'; 
select time_format(@v2, '%TZR %TZD %TZH %TZM'); 
execute st using @v2, '%TZR %TZD %TZH %TZM';

select time_format(datetimeltz'2025-12-31 22:30:45.999 America/Sao_Paulo', '%TZR %TZD %TZH %TZM');
execute st using datetimeltz'2025-12-31 22:30:45.999 America/Sao_Paulo', '%TZR %TZD %TZH %TZM'; 
select time_format(@v3, '%TZR %TZD %TZH %TZM'); 
execute st using @v3, '%TZR %TZD %TZH %TZM';

select time_format(datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', '%TZR %TZD %TZH %TZM'); 
execute st using datetimetz'2025-12-31 22:30:45.999 America/Sao_Paulo', '%TZR %TZD %TZH %TZM'; 
select time_format(@v4, '%TZR %TZD %TZH %TZM'); 
execute st using @v4, '%TZR %TZD %TZH %TZM';

set timezone 'Asia/Seoul';

--+ server-message off
