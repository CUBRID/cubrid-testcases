--TEST: pass marginal values to the 2nd param


--TEST: 1. marginal values: string type of date format
select addtime(time'14:59:59', '0001-01-01');

select addtime(time'14:59:59', '9999-12-31');

select addtime(time'14:59:59', '12/31/9999');

select addtime(time'14:59:59', '1/1/1');




--TEST: 2. marginal values: string type of timestamp format
select addtime(time'14:59:59', '00:00:00 01/01/01');

select addtime(time'14:59:59', '03:14:07 1/19/2038');

select addtime(time'14:59:59', '0:0:0 PM 1970-01-01');

select addtime(time'14:59:59', '1/19/2038 03:14:07 pm');




--TEST: 3. marginal values: string type of datetime format
select addtime(time'14:59:59', '0:0:0.00 1/1/1');

select addtime(time'14:59:59', '23:59:59.999 12/31/9999');

select addtime(time'14:59:59', '00:00:00.0000 AM 0001-01-01');

select addtime(time'14:59:59', '12/31/9999 23:59:59.999');



--TEST: 4. marginal values: string type of time formatselect addtime(time'14:59:59', '0:0:0.00 1/1');
select addtime(time'0:0:0', '0:0:0.00');

select addtime(time'14:59:59', '23:59:59');

select addtime(time'14:59:59', '00:00:00');

select addtime(time'0:0:1', '23:59:59.999');


