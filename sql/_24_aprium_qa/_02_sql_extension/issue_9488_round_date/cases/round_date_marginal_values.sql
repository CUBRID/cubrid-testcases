--pass maginal values to the first parameter


--TEST: round marginal values of year
select round(date'1999-06-30', 'yyyy');
select round(date'1999-07-01', 'yyyy');
select round(date'1999-07-02', 'yyyy');

--TEST: round marginal values of quarter
select round(date'2000-08-15', 'Q');
select round(timestamp'2000-08-16 12:12:12', 'Q');
select round(date'2000-08-17', 'Q');

--TEST: round marginal values of month
select round(date'2012-02-15', 'month');
select round(date'2012-02-16', 'month');
select round(datetime'2012-02-16 12:1:1.123', 'mm');

--TEST: round marginal values of week
select round(date'2011-06-12', 'd');
select round(date'2011-06-13', 'd');
select round(timestamp'2011-06-14 11:11:11', 'd');
select round(date'2011-06-15', 'd');
select round(date'2011-06-16', 'd');
select round(date'2011-06-17', 'd');
select round(datetime'2011-06-18 11:11:11.999', 'd');

--TEST: round marginal values of dd/hh/mi/ss/ff
select round(timestamp'1999-02-15 23:59:59', 'q');
select round(timestamp'2011-5-31 13:11:12', 'dd');
select round(timestamp'2011-5-31 11:59:59', 'dd');
select round(timestamp'2011-5-31 23:31:12', 'hh');
select round(timestamp'2011-5-31 23:29:12', 'hh');
select round(timestamp'2011-5-31 23:59:30', 'mi');
select round(timestamp'2011-5-31 23:59:29', 'mi');
select round(datetime'2011-5-31 23:59:59.500', 'ss');
select round(datetime'2011-5-31 23:59:59.499', 'ss');
select round(datetime'2011-5-31 23:59:59.999', 'ff');

--TEST: zero date
select round(date'0000-00-00', 'yy');
select round(timestamp'0000-00-00 0:0:0', 'dd');
select round(datetime'0000-00-00 0:0:0.0', 'month');
select round('0000-00-00', 'dy');
