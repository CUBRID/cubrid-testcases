--basic test
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'yyyy');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'yy');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'mon');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'mm');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'dd');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'hh');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'mi');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'ss');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'ff');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'day');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'dy');
select trunc(to_datetime('2012-10-26 16:20:45.116'), 'q');

select trunc(to_date('2012-10-26'), 'yyyy');
select trunc(to_date('2012-10-26'), 'yy');
select trunc(to_date('2012-10-26'), 'mon');
select trunc(to_date('2012-10-26'), 'mm');
select trunc(to_date('2012-10-26'), 'dd');
select trunc(to_date('2012-10-26'), 'hh');
select trunc(to_date('2012-10-26'), 'mi');
select trunc(to_date('2012-10-26'), 'ss');
select trunc(to_date('2012-10-26'), 'ff');
select trunc(to_date('2012-10-26'), 'day');
select trunc(to_date('2012-10-26'), 'dy');
select trunc(to_date('2012-10-26'), 'q');

--week day test
select trunc('2012-10-21', 'dy');
select trunc('2012-10-22', 'dy');
select trunc('2012-10-23', 'dy');
select trunc('2012-10-24', 'dy');
select trunc('2012-10-25', 'dy');
select trunc('2012-10-26', 'dy');
select trunc('2012-10-27', 'dy');
select trunc('2012-10-28', 'dy');
select trunc('2012-10-29', 'dy');

--special case test
select trunc('2012-6-2', 'dy');
select trunc('2010-1-2', 'dy');

--negative
select trunc('2010-1-2', 'a');
select trunc('2010-1-2', 3);
select trunc(1234, 'yyyy');
