--TEST: use function as an argument


--TEST: argument of string type
select addtime(to_char(to_timestamp('19:39:45 PM 12/12/2012')), time'13:59:59');


--TEST: argument of date type
select addtime(adddate(date'04/12/2010', 20), time'13:59:59');
select addtime(subdate(date'04/12/2010', 20), time'13:59:59');
select addtime(add_months(date'04/12/2010', -6), time'13:59:59');
select addtime(date('2001-10-18 10:14:25'), time'13:59:59');
select addtime(last_day('1898-05-06'), time'13:59:59');
select addtime(str_to_date('01,5,2015', '%m,%d,%y'), time'13:59:59');
select addtime(to_date('10/10/1010'), time'13:59:59');


--TEST: argument of timestamp type
select addtime(to_timestamp('19:39:45 PM 12/12/2012'), time'13:59:59');


--TEST: argument of datetime type
select addtime(timestamp('2010-10-28', '15:49:33'), time'13:59:59');
select addtime(to_datetime('01:23:33 am 10/23/1988'), time'13:59:59');



--TEST: server side
create table too(str1 string, str2 char(30));

insert into too values('19:39:45 PM 12/12/2012', '2011-11-11');

select addtime(to_char(to_timestamp(str1)), time'13:59:59') from too;
select addtime(to_datetime(str1), time'13:59:59') from too;
select addtime(to_timestamp(str1), time'13:59:59') from too;

select addtime(to_date(str2), time'13:59:59') from too;


drop table too;
