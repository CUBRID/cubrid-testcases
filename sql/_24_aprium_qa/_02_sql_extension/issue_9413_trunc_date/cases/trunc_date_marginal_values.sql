--pass maginal values to the first parameter


--TEST: round marginal values of year
select trunc('1999-06-30', 'yyyy');
select trunc(date'1999-07-01', 'yyyy');
select trunc('1999-07-02', 'yyyy');

--TEST: round marginal values of quarter
select trunc(date'2000-08-15', 'Q');
select trunc(timestamp'2000-08-16 12:12:12', 'Q');
select trunc(date'2000-08-17', 'Q');

--TEST: round marginal values of month
select trunc(date'2012-02-15', 'month');
select trunc(date'2012-02-16', 'month');
select trunc(datetime'2012-02-16 12:1:1.123', 'mm');

--TEST: round marginal values of week
select trunc(date'2011-06-12', 'day');
select trunc(date'2011-06-13', 'dy');
select trunc(timestamp'2011-06-14 11:11:11', 'd');
select trunc(date'2011-06-15', 'day');
select trunc(date'2011-06-16', 'dy');
select trunc(date'2011-06-17', 'd');
select trunc(datetime'2011-06-18 11:11:11.999', 'd');

--TEST: zero date
select trunc(date'0000-00-00', 'yy');
select trunc(timestamp'0000-00-00 0:0:0', 'dd');
select trunc(datetime'0000-00-00 0:0:0.0', 'month');
select trunc('0000-00-00', 'dy');
select trunc(date'0001-01-01', 'yyyy');
select trunc(date'0001-01-01', 'dd');
select trunc(date'0001-01-01', 'day');

--TEST: max date
select trunc(date'9999-12-31', 'dd');
select trunc(date'9999-12-31', 'day');
select trunc(date'9999-12-31', 'yyyy');
