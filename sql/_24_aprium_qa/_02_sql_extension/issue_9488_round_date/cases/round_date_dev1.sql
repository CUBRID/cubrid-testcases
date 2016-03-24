--basic test
select round(to_datetime('2012-10-26 16:20:45.116'), 'yyyy');
select round(to_datetime('2012-10-26 16:20:45.116'), 'yy');
select round(to_datetime('2012-10-26 16:20:45.116'), 'mon');
select round(to_datetime('2012-10-26 16:20:45.116'), 'mm');
select round(to_datetime('2012-10-26 16:20:45.116'), 'dd');
select round(to_datetime('2012-10-26 16:20:45.116'), 'hh');
select round(to_datetime('2012-10-26 16:20:45.116'), 'mi');
select round(to_datetime('2012-10-26 16:20:45.116'), 'ss');
select round(to_datetime('2012-10-26 16:20:45.116'), 'ff');
select round(to_datetime('2012-10-26 16:20:45.116'), 'day');
select round(to_datetime('2012-10-26 16:20:45.116'), 'dy');
select round(to_datetime('2012-10-26 16:20:45.116'), 'q');

select round(to_date('2012-10-26'), 'yyyy');
select round(to_date('2012-10-26'), 'yy');
select round(to_date('2012-10-26'), 'mon');
select round(to_date('2012-10-26'), 'mm');
select round(to_date('2012-10-26'), 'dd');
select round(to_date('2012-10-26'), 'hh');
select round(to_date('2012-10-26'), 'mi');
select round(to_date('2012-10-26'), 'ss');
select round(to_date('2012-10-26'), 'ff');
select round(to_date('2012-10-26'), 'day');
select round(to_date('2012-10-26'), 'dy');
select round(to_date('2012-10-26'), 'q');

--week day test
select round('2012-10-21', 'dy');
select round('2012-10-22', 'dy');
select round('2012-10-23', 'dy');
select round('2012-10-24', 'dy');
select round('2012-10-25', 'dy');
select round('2012-10-26', 'dy');
select round('2012-10-27', 'dy');
select round('2012-10-28', 'dy');
select round('2012-10-29', 'dy');

--special case test
select round('2012-6-2', 'dy');
select round('2010-1-2', 'dy');

--negative
select round('2010-1-2', 'a');
select round('2010-1-2', 3);
select round(1234, 'yyyy');
