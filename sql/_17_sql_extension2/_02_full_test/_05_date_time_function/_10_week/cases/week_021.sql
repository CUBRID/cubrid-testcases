--exceptional cases whenuseing function as an argument


--argument of string type
select week(time_format('10:17:66', '%H:%i:%s'));
select week(to_char(datetime'1111-10-55 12:23:22.111'), 3);


--argument of time type
select week(adddate(date'20/12/2010', 20));
select week(subdate(date'04/45/2010', 20), null);
select week(add_months(date'04/12/20105', -6));
select week(date('2001-10-188 10:14:25'));
select week(last_day('1898-15-06'), 100);
select week(str_to_date('a,b,c', '%m,%d,%y'));
select week(to_date(2000));



--argument of timestamp type
select week(to_timestamp('19:39:45 BM 12/12/2012'));
select week(to_timestamp('19:39:45 BM 12/12/2012'), least(to_date('2010-10-10'), '222222'));


--argument of datetime type
select week(timestamp('2010-10-28', 'abcabcabc'));
select week(to_datetime(123456), ifnull(null, null));



--server side
create table too(str1 int, str2 string);

insert into too values(1234, 'aabbcc');

select week(to_char(to_timestamp(str1))) from too;
select week(to_datetime(str1), floor(2.200010101010101333)) from too;
select week(to_timestamp(str1)) from too;

select week(to_time(str2), round(22222.3434343)) from too;
select week(time_format(str2, '%H:%i:%s')) from too;


drop table too;
