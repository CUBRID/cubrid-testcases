--TEST: pass different formats of date/timestamptz/datetimetz arguments to the 2nd parameter


--TEST: 1. pass different formats of date arguments
select addtime(timestamptz'2011-10-26 14:59:59', date'2010-10-08');

--TEST: ?? date without year, it returns null in mysql
select addtime(timestamptz'2011-10-26 14:59:59', date'12-25');

select addtime(timestamptz'2011-10-26 14:59:59', date'8/30');

select addtime(timestamptz'2011-10-26 14:59:59', date'11/09/1864');



--TEST: 2. pass different formats of timestamptz arguments
select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'13:14:55 10/08');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'2:22:22 8/12/2010');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'09:03:22 PM 1988-08-08');

select addtime(timestamptz'2011-10-26 14:59:59', timestamptz'12/12/2022 10:20:55');



--TEST: 3. pass different formats of datetimetz arguments
select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'13:14:55.123 10/08');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'2:22:22.333 8/12/2010');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'09:03:22.012 PM 1988-08-08');

select addtime(timestamptz'2011-10-26 14:59:59', datetimetz'12/12/1556 10:20:55.567');



--TEST: 4. pass time arguments
select addtime(timestamptz'2011-10-26 14:59:59', time'13:14:55');

select addtime(timestamptz'2011-10-26 14:59:59', time'2:22:22');

select addtime(timestamptz'2011-10-26 14:59:59', time'09:03:22');

select addtime(timestamptz'2011-10-26 14:59:59', time'10:20:55');


