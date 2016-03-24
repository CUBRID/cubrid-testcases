--TEST: pass exceptional data of date/timetz type to the 2nd parameter



--TEST: 1. [error] exceptional argument of date type
select addtime(timestamptz'2011-10-26 14:59:59', date'0000/000/00',);

select addtime(timestamptz'2011-10-26 14:59:59', date'12\23\2009');

select addtime(timestamptz'2011-10-26 14:59:59', date'01 2-2000');

select addtime(timestamptz'2011-10-26 14:59:59', date'1988-12-12-11');

select addtime(timestamptz'2011-10-26 14:59:59', date'aa/bb/cc');



--TEST: 2. [error] exceptional argument of timestamptz type
select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'23:00:00 11/001');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'04:14:07 1/0019/2011');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'03:15,07 1/19/1999');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'03:14:08 hm 1/19/2010');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'03:14:07 3\22\1998');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'03:14:07 a/b/c');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'11:03:22 PM 1993--TEST: 01--23');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'2000=12=12 22:02:33');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'2020-23-11 03:14:45pm');



--TEST: 3. [error] exceptional argument of datetimetz type
select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'2010-10 10:10:00001.0000001 am');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'20:59:59.999 0012/00031/1999');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'1::2::3:4 12/31/9999');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'23:59:33:44:555 12/31/9999');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'20:23:45.23 12\31\2000');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'20:23:45.23 a/b/c');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'20:33:21.111 1990-10--TEST: 19 ');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'2/12/2022 10:20:cc:400');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'12/31/1989 23:59:59.123am');


--TEST: 4. [error] empty, null and unmatched number of argument
select addtime(timestamptz'2011-10-26 14:59:59', date'');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz' ');


