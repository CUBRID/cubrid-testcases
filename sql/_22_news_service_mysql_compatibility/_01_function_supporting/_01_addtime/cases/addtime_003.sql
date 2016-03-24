--TEST: pass different formats of string arguments to the 1st parameter 


--TEST: 1. string values of date format
select addtime('2010-10-08', time'9:19:29');

--TEST: date without year
select addtime('12-12-25', time'9:19:29');

select addtime('8/30/76', time'9:19:29');

select addtime('11/09/1864', time'9:19:29');



--TEST: 2. string values of timestamp format
select addtime('13:14:55 10/08/01', time'9:19:29');

select addtime('2:22:22 8/12/2010', time'9:19:29');

select addtime('09:03:22 PM 1988-08-08', time'9:19:29');

select addtime('12/12/2022 10:20:55', time'9:19:29');



--TEST: 3. string values of datetime format
select addtime('13:14:55.123 10/08/01', time'9:19:29');

select addtime('2:22:22.333 8/12/2010', time'9:19:29');

select addtime('09:03:22.012 PM 1988-08-08', time'9:19:29');

select addtime('12/12/1556 10:20:55.567', time'9:19:29');



--TEST: 4. string values of time format
select addtime('13:14:55.123', time'9:19:29');

select addtime('2:22:22.333', time'9:19:29');

select addtime('10:20:55.567', time'9:19:29');


