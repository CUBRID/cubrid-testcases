--TEST: trunc(date) function does not work when the second(format) parameter is omitted.


select trunc(date'1999-12-20');
select trunc(datetime'1999-12-20 23:45:59.345');
select trunc(timestamp'1999-12-20 23:45:59');
select trunc(to_date('2012-12-9', 'yyyy-mm-dd'));
select trunc(123);
select trunc(123.123);
select trunc(2147483647);
select trunc(2147483648);
select trunc('123.123');

prepare s from 'select trunc(?)';
execute s using date'1999-12-20';
execute s using datetime'1999-12-20 23:45:59.345';
execute s using timestamp'1999-12-20 23:45:59';
execute s using 123;
execute s using 123.123;
execute s using 2147483647;
execute s using 2147483648;
execute s using '123.123';
deallocate prepare s;

select trunc('1999-12-12');
