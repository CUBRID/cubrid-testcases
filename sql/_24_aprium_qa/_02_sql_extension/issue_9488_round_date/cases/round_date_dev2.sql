
--round with year
select round(timestamp'11:59:59 pm 2012-07-01', 'yy');
select round(timestamp'11:59:59 pm 2012-06-30', 'yy');
select round(timestamp'11:59:59 pm 2012-01-01', 'yyyy');
select round(timestamp'11:59:59 pm 2012-12-31', 'yyyy');
--round with month
select round(timestamp'11:59:59 pm 2012-02-15', 'mm');
select round(timestamp'11:59:59 pm 2012-02-16', 'mm');
select round(timestamp'11:59:59 pm 2012-12-15', 'mon');
select round(timestamp'11:59:59 pm 2012-12-16', 'month');
--round with day
select round(to_datetime('11:59:59.499 am 2012-02-28'), 'dd');
select round(to_datetime('11:59:59.499 am 2012-02-29'), 'dd');
select round(to_datetime('11:59:59.499 pm 2011-02-28'), 'dd');
select round(to_datetime('11:59:59.499 pm 2012-12-31'), 'dd');

select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'dd');
select round(to_datetime('11:59:59.499 pm 2012-02-29'), 'dd');
select round(to_datetime('11:59:59.499 pm 2011-02-28'), 'dd');
select round(to_datetime('11:59:59.499 pm 2012-12-31'), 'dd');
--round with hour
select round(to_datetime('01:29:59.499 am 2012-02-28'), 'h');
select round(to_datetime('01:30:59.499 am 2012-02-29'), 'h');
select round(to_datetime('11:29:59.499 am 2011-02-28'), 'h');
select round(to_datetime('11:30:59.499 am 2012-12-31'), 'h');

select round(to_datetime('01:29:59.499 pm 2012-02-28'), 'hh');
select round(to_datetime('01:30:59.499 pm 2012-02-29'), 'hh');
select round(to_datetime('11:29:59.499 pm 2011-02-28'), 'hh');
select round(to_datetime('11:30:59.499 pm 2012-12-31'), 'hh');
--round with minute
select round(to_datetime('01:59:29.499 am 2012-02-28'), 'mi');
select round(to_datetime('01:59:30.499 am 2012-02-29'), 'mi');
select round(to_datetime('11:59:29.499 am 2011-02-28'), 'mi');
select round(to_datetime('11:59:30.499 am 2012-12-31'), 'mi');

select round(to_datetime('01:59:29.499 pm 2012-02-28'), 'mi');
select round(to_datetime('01:59:30.499 pm 2012-02-29'), 'mi');
select round(to_datetime('11:59:29.499 pm 2011-02-28'), 'mi');
select round(to_datetime('11:59:30.499 pm 2012-12-31'), 'mi');
--round with second
select round(to_datetime('01:59:59.499 am 2012-02-28'), 'ss');
select round(to_datetime('01:59:59.499 am 2012-02-29'), 'ss');
select round(to_datetime('11:59:59.499 am 2011-02-28'), 'ss');
select round(to_datetime('11:59:59.499 am 2012-12-31'), 'ss');

select round(to_datetime('01:59:59.500 pm 2012-02-28'), 'ss');
select round(to_datetime('01:59:59.500 pm 2012-02-29'), 'ss');
select round(to_datetime('11:59:59.500 pm 2011-02-28'), 'ss');
select round(to_datetime('11:59:59.500 pm 2012-12-31'), 'ss');

--normal
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'yy') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'mm') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'dd') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'hh') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'mi') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-28'), 'ss') from db_root;

--for leap year
select round(to_datetime('11:59:59.500 pm 2012-02-28'), 'yy') from db_root;
select round(to_datetime('11:59:59.500 pm 2012-02-28'), 'mm') from db_root;
select round(to_datetime('11:59:59.500 pm 2012-02-28'), 'dd') from db_root;
select round(to_datetime('11:59:59.500 pm 2012-02-28'), 'hh') from db_root;
select round(to_datetime('11:59:59.500 pm 2012-02-28'), 'mi') from db_root;
select round(to_datetime('11:59:59.500 pm 2012-02-28'), 'ss') from db_root;
--for non leap year
select round(to_datetime('11:59:59.500 pm 2011-02-28'), 'yy') from db_root;
select round(to_datetime('11:59:59.500 pm 2011-02-28'), 'mm') from db_root;
select round(to_datetime('11:59:59.500 pm 2011-02-28'), 'dd') from db_root order by 1;
select round(to_datetime('11:59:59.500 pm 2011-02-28'), 'hh') from db_root;
select round(to_datetime('11:59:59.500 pm 2011-02-28'), 'mi') from db_root;
select round(to_datetime('11:59:59.500 pm 2011-02-28'), 'ss') from db_root;

--for round up year:
select round(to_datetime('11:59:59.500 pm 2011-12-31'), 'yy') from db_root order by 1;
select round(to_datetime('11:59:59.500 pm 2011-12-31'), 'mm') from db_root order by 1;
select round(to_datetime('11:59:59.500 pm 2011-12-31'), 'dd') from db_root order by 1;
select round(to_datetime('11:59:59.500 pm 2011-12-31'), 'hh') from db_root order by 1;
select round(to_datetime('11:59:59.500 pm 2011-12-31'), 'mi') from db_root order by 1;
select round(to_datetime('11:59:59.500 pm 2011-12-31'), 'ss') from db_root order by 1;


--for quater:
select round(to_datetime('11:59:59.499 pm 2012-02-15'), 'q') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-02-16'), 'q') from db_root;

select round(to_datetime('11:59:59.499 pm 2012-05-15'), 'q') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-05-16'), 'q') from db_root;

select round(to_datetime('11:59:59.499 pm 2012-08-15'), 'q') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-08-16'), 'q') from db_root;

select round(to_datetime('11:59:59.499 pm 2012-11-15'), 'q') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-11-16'), 'q') from db_root;

--for day:
select round(to_datetime('11:59:59.499 pm 2012-11-19'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-11-20'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-11-21'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-11-22'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-11-23'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-11-24'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-11-25'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-12-26'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-12-27'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-12-28'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-12-29'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-12-30'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2012-12-31'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2013-01-01'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2013-01-02'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2013-01-03'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2013-01-04'), 'day') from db_root;
select round(to_datetime('11:59:59.499 pm 2013-01-05'), 'day') from db_root;

--negative
select round(to_datetime('11:59:59.499 pm 2013-01-05'), 'test');
select round(to_datetime('11:59:59.499 pm 2013-01-05'), 3);
select round(123.456 , 'yy');
