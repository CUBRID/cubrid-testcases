--TEST: pass different formats of date/timestampltz/datetimeltz arguments to the 1st parameter

set timezone '+9:00';

--TEST: 1. pass different formats of date arguments
select addtime(date'2010-10-08', time'9:19:29');

select addtime(date'12-12-25', time'9:19:29');

select addtime(date'8/30/99', time'9:19:29');

select addtime(date'11/09/1864', time'9:19:29');



--TEST: 2. pass different formats of timestampltz arguments
select addtime(timestampltz'10/08/01 13:14:55', time'9:19:29');

select addtime(timestampltz'2:22:22 8/12/2010', time'9:19:29');

select addtime(timestampltz'1988-08-08 09:03:22', time'9:19:29');

select addtime(timestampltz'12/12/2033 10:20:55', time'9:19:29');



--TEST: 3. pass different formats of datetimeltz arguments
select addtime(datetimeltz'10/08/01 13:14:55.123', time'9:19:29');

select addtime(datetimeltz'2:22:22.333 8/12/2010', time'9:19:29');

select addtime(datetimeltz'09:03:22.012 PM 1988-08-08', time'9:19:29');

select addtime(datetimeltz'12/12/1556 10:20:55.567', time'9:19:29');



--TEST: 4. pass time arguments
select addtime(time'13:14:55', time'9:19:29');

select addtime(time'2:22:22', time'9:19:29');

select addtime(time'09:03:22', time'9:19:29');

select addtime(time'10:20:55', time'9:19:29');


set timezone 'Asia/Seoul';
