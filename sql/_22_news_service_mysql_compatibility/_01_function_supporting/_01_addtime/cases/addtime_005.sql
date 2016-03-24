--TEST: pass different formats of date/timestamp/datetime arguments to the 1st parameter


--TEST: 1. pass different formats of date arguments
select addtime(date'2010-10-08', time'9:19:29');

select addtime(date'12-12-25', time'9:19:29');

select addtime(date'8/30/99', time'9:19:29');

select addtime(date'11/09/1864', time'9:19:29');



--TEST: 2. pass different formats of timestamp arguments
select addtime(timestamp'10/08/01 13:14:55', time'9:19:29');

select addtime(timestamp'2:22:22 8/12/2010', time'9:19:29');

select addtime(timestamp'1988-08-08 09:03:22', time'9:19:29');

select addtime(timestamp'12/12/2033 10:20:55', time'9:19:29');



--TEST: 3. pass different formats of datetime arguments
select addtime(datetime'10/08/01 13:14:55.123', time'9:19:29');

select addtime(datetime'2:22:22.333 8/12/2010', time'9:19:29');

select addtime(datetime'09:03:22.012 PM 1988-08-08', time'9:19:29');

select addtime(datetime'12/12/1556 10:20:55.567', time'9:19:29');



--TEST: 4. pass time arguments
select addtime(time'13:14:55', time'9:19:29');

select addtime(time'2:22:22', time'9:19:29');

select addtime(time'09:03:22', time'9:19:29');

select addtime(time'10:20:55', time'9:19:29');


