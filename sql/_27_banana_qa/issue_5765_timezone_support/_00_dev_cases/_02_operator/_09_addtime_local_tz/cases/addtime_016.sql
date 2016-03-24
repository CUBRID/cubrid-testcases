--TEST: pass exceptional data of timeltz/timestampltz/datetimeltz type to the parameter


--TEST: 1. [error] exceptional argument of date type
select addtime(date'000/000/000', '9:19:29');

select addtime(date'12\30\2009', '9:19:29');

select addtime(date'1999-10=21', '9:19:29');

select addtime(date'12/14/2012/33', '9:19:29');

select addtime(date'-11/23/1898', '9:19:29');

select addtime(date'aa-bb-cc', '9:19:29');



--TEST: 2. [error] exceptional argument of timestampltz type
--gaoym:modify select addtime(timestampltz'23:00:00 11/001', '9:19:29'); to two sqls
--select addtime(timestampltz'23:00:00 11/001', '9:19:29');
select if(year(sysdate)=right(to_char(addtime(timestampltz'23:00:00 11/001', '9:19:29')),4),'ok','nok'); 
select if('08:19:29.000 AM 11/02/'=left(to_char(addtime(timestampltz'23:00:00 11/001', '9:19:29')),22),'ok','nok'); 

select addtime(timestampltz'04:14:07 1/0019/2011', '9:19:29');

select addtime(timestampltz'03:15,07 1/19/1999', '9:19:29');

select addtime(timestampltz'03:14:08 hm 1/19/2010', '9:19:29');

select addtime(timestampltz'03:14:07 3\22\1998', '9:19:29');

select addtime(timestampltz'03:14:07 a/b/c', '9:19:29');

select addtime(timestampltz'11:03:22 PM 1993--TEST: 01--23', '9:19:29');

select addtime(timestampltz'2000=12=12 22:02:33', '9:19:29');

select addtime(timestampltz'2020-23-11 03:14:45pm', '9:19:29');



--TEST: 3. [error] exceptional argument of datetimeltz type
select addtime(datetimeltz'2010-10 10:10:00001.0000001 am', '9:19:29');

select addtime(datetimeltz'20:59:59.999 0012/00031/1999', '9:19:29');

select addtime(datetimeltz'1::2::3.4 12/31/9999', '9:19:29');

select addtime(datetimeltz'23:59:33:44:555 12/31/9999', '9:19:29');

select addtime(datetimeltz'20:23:45.23 12\31\2000', '9:19:29');

select addtime(datetimeltz'20:23:45.23 a/b/c', '9:19:29');

select addtime(datetimeltz'20:33:21.111 1990-10--TEST: 19 ', '9:19:29');

select addtime(datetimeltz'2/12/2022 10:20:cc.400', '9:19:29');

select addtime(datetimeltz'12/31/1989 23:59:59.123am', '9:19:29');


--TEST: 4. [error] unmatched number of argument
select addtime(timestampltz'2010-10-10 12:34:33', 3, 888);

select addtime(date'2010-10-28', 555, 'a');

select addtime(datetimeltz'10:10:10.100 12/22/2022', 'aaa', 'bbb');
