--TEST: exceptional cases whenuseing function as an argument


--TEST: argument of string type
select addtime(time_format('10:17:66', '%H:%i:%s'), time'23:59:59');
select addtime(to_char(datetimetz'1111-10-55 12:23:22.111'), time'23:59:59');


--TEST: argument of time type
select addtime(adddate(date'20/12/2010', 20), time'23:59:59');
select addtime(subdate(date'04/45/2010', 20), null, time'23:59:59');
select addtime(add_months(date'04/12/20105', -6), time'23:59:59');
select addtime(date('2001-10-188 10:14:25'), time'23:59:59');
select addtime(last_day('1898-15-06'), 100, time'23:59:59');
select addtime(str_to_date('a,b,c', '%m,%d,%y'), time'23:59:59');
select addtime(to_date(2000), time'23:59:59');



--TEST: argument of timestamptz type
select addtime(to_timestamp('19:39:45 BM 12/12/2012'), time'23:59:59');
select addtime(to_timestamp('19:39:45 BM 12/12/2012'), least(to_date('2010-10-10'), '222222'), time'23:59:59');


--TEST: argument of datetimetz type
select addtime(timestamptz('2010-10-28', 'abcabcabc'), time'23:59:59');
select addtime(to_datetime(123456), ifnull(null, null), time'23:59:59');



--TEST: server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select addtime(to_char(to_timestamp(str1)), time'23:59:59') from too;
select addtime(to_datetime(str1), time'23:59:59') from too;
select addtime(to_timestamp(str1), time'23:59:59') from too;

select addtime(to_time(str2), time'23:59:59') from too;
select addtime(time_format(str2, '%H:%i:%s'), time'23:59:59') from too;


drop table too;
