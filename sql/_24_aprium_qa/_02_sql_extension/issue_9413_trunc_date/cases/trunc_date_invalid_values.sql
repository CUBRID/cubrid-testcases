--pass in valid values to the parameters


--TEST: out-of-range value to the first param
select trunc(date'2013-13-12', 'mon');
select trunc('1999-12-32', 'yy');

--TEST: unmatched type/invalid value to the first param
select trunc(123, 'dy');
select trunc('abc', 'dd');

--TEST: unmatched type/invalid value to the second param
select trunc('2012-12-12', 5);
select trunc(to_date('1999-03-23'), 'year');

--TEST: null values
select trunc(null, 'mon');
select trunc(date'1876-10-23', null);
select trunc(null, null);

--TEST: empty string value
select trunc('', 'yyyy');
select trunc('2012-12-12', '');

--TEST: unmatched number of arguments
select trunc();
select trunc('2012-12-12', 'mm', null);
