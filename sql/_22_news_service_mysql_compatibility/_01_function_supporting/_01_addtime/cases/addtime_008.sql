--TEST: pass marginal values of date/timestamp/datetime type to the 1st param


--TEST: 1. marginal values: date argument
select addtime(date'0001-01-01', '9:19:29');

select addtime(date'9999-12-31', '9:19:29');

select addtime(date'12/31/9999', '9:19:29');

select addtime(date'1/1/1', '9:19:29');




--TEST: 2. marginal values: timestamp argument
select addtime(timestamp'00:00:00 01/01/01', '9:19:29');

select addtime(timestamp'03:14:07 1/19/2038', '9:19:29');

select addtime(timestamp'0:0:0 PM 1970-01-01', '9:19:29');

select addtime(timestamp'1/19/2038 03:14:07', '9:19:29');



--TEST: 3. marginal values: datetime argument
select addtime(datetime'0:0:0.00 1/1/1', '9:19:29');

select addtime(datetime'23:59:59.999 12/31/9999', '9:19:29');

select addtime(datetime'00:00:00.0000 AM 0001-01-01', '9:19:29');

select addtime(datetime'12/31/9999 23:59:59.999', '0:0:0.000');

select addtime(datetime'12/31/9999 23:59:59.999', '0:0:0.001');



--TEST: 4. marginal values: time argument
select addtime('0:0:0.00', '9:19:29');

select addtime('23:59:59', '0:0:1');

select addtime('00:00:00', '9:19:29');

select addtime('23:59:59.999', '0:0:0.001');
