--TEST: pass marginal values of date/timestampltz/datetimeltz type to the 2nd param

set timezone '+9:00';

--TEST: 1. marginal values: date argument
select addtime(time'14:59:59', date'0001-01-01');

select addtime(time'14:59:59', date'9999-12-31');

select addtime(time'14:59:59', date'12/31/9999');

select addtime(time'14:59:59', date'1/1/1');




--TEST: 2. marginal values: timestampltz argument
select addtime(time'14:59:59', timestampltz'00:00:00 01/01/01');

select addtime(time'14:59:59', timestampltz'03:14:07 1/19/2038');

select addtime(time'14:59:59', timestampltz'0:0:0 PM 1970-01-01');

select addtime(time'14:59:59', timestampltz'1/19/2038 03:14:07');



--TEST: 3. marginal values: datetimeltz argument
select addtime(time'14:59:59', datetimeltz'0:0:0.00 1/1/1');

select addtime(time'14:59:59', datetimeltz'23:59:59.999 12/31/9999');

select addtime(time'14:59:59', datetimeltz'00:00:00.0000 AM 0001-01-01');

select addtime(time'14:59:59', datetimeltz'12/31/9999 23:59:59.999');



--TEST: 4. marginal values: time argument
select addtime(time'14:59:59', time'0:0:0.0000000000000000');

select addtime(time'0:0:01', time'23:59:59');

select addtime(time'14:59:59', time'00:00:00');

select addtime(time'0:0:0.001', time'23:59:59.999');


set timezone 'Asia/Seoul';
