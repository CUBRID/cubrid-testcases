--Test for datetime 'YYMMDDH'

select adddate('1212129',-1);
select date('1212129');
select add_months(date('1204039'),5);
select datediff('1204039','2012-04-03');
select subdate('1204039',1);
select day('1204039');
select dayofmonth('1204309');
select dayofweek('1204309');
select dayofyear('1204039');
select extract(year from '1204039');
select extract(month from '1204039');
select extract(day from '1204039');
select extract(hour from '1204039');
select extract(minute from '1204039');
select extract(second from '1204039');
select extract(millisecond from '1204039');
select last_day('1204039');
select month('1204039');
select months_between('1204039','2012-04-02');
select to_days('1010042');
select week('1202042',0);
select year('1202042');
SELECT WEEKDAY('1208019');


create table da(d date);
insert into da values(adddate('1212129',-1));
insert into da values(date('1212129'));
select * from da order by 1;
delete from da;
drop table da;


