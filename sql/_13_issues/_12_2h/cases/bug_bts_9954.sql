--TEST: 'D'/'d' format is not supported in trunc(date) function.


select trunc('2012-10-21', 'd');
select trunc('2012-10-22', 'd');
select trunc('2012-10-23', 'd');
select trunc('2012-10-24', 'd');
select trunc('2012-10-25', 'd');
select trunc('2012-10-26', 'd');
select trunc('2012-10-27', 'd');
select trunc('2012-10-28', 'd');
select trunc('2012-10-29', 'd');
