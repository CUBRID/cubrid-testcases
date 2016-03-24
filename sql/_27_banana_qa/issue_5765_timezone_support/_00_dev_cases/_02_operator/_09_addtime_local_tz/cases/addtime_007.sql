--TEST: pass marginal values to the 1st param


--TEST: 1. marginal values: string type of date format
select addtime('0001-01-01', '9:19:29');

select addtime('9999-12-31', '9:19:29');

select addtime('12/31/9999', '9:19:29');

select addtime('1/1/1', '9:19:29');




--TEST: 2. marginal values: string type of timestampltz format
select addtime('00:00:00 01/01/01', '9:19:29');

select addtime('03:14:07 1/19/2038', '9:19:29');

select addtime('0:0:0 PM 1970-01-01', '9:19:29');

select addtime('1/19/2038 03:14:07 pm', '9:19:29');


--TEST: 3. marginal values: string type of datetimeltz format
select addtime('0:0:0.00 1/1/1', '9:19:29');

select addtime('23:59:59.999 12/31/9999', '9:19:29');

select addtime('00:00:00.0000 AM 0001-01-01', '9:19:29');

select addtime('12/31/9999 23:59:59.999', '0:0:1');



--TEST: 4. marginal values: string type of timeltz format
select addtime('00:00:00', '9:19:29');

select addtime('23:59:59', '0:0:1');

select addtime('0:0:0', '23:59:59');

select addtime('23:58:58', '0:1:2');
