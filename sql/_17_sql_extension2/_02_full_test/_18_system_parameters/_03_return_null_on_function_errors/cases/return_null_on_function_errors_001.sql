--+ holdcas on;
--normal test

set system parameters 'return_null_on_function_errors=no';

select time('abc');
select year('bbb');
select month('ccc');
select day('abc');
select dayofmonth('abc');
select minute('abc');
select second('abc');
select quarter('abc');
select week('abc');
select weekday('abc');
select dayofweek('abc');
select sec_to_time('');
select time_to_sec('abc');
select to_days('abc');
select from_days('abc');
select makedate('abc', 'a', 'b');
select maketime('abc', 'a', 123);
select timediff('abc', 123);


set system parameters 'return_null_on_function_errors=yes';

select time('abc');
select year('bbb');
select month('ccc');
select day('abc');
select dayofmonth('abc');
select minute('abc');
select second('abc');
select quarter('abc');
select week('abc');
select weekday('abc');
select dayofweek('abc');
select sec_to_time('abc');
select time_to_sec('abc');
select to_days('abc');
select from_days('abc');
select makedate('abc', 'a', 'b');
select maketime('abc', 'a', 123);
select timediff('abc', 123);

set system parameters 'return_null_on_function_errors=123';
set system parameters 'return_null_on_function_errors=abc';
set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
