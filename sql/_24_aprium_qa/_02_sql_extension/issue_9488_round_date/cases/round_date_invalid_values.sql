--pass in valid values to the parameters


--TEST: out-of-range value to the first param
select round(date'2013-13-12', 'mon');
select round('1999-12-32', 'yy');

--TEST: unmatched type/invalid value to the first param
select round(123, 'dy');
select round('abc', 'dd');

--TEST: unmatched type/invalid value to the second param
select round('2012-12-12', 5);
select round(to_date('1999-03-23'), 'year');

--TEST: null values
select round(null, 'mon');
select round(date'1876-10-23', null);
select round(null, null);

--TEST: empty string value
select round('', 'yyyy');
select round('2012-12-12', '');

--TEST: unmatched number of arguments
select round();
select round('2012-12-12', 'mm', null);
