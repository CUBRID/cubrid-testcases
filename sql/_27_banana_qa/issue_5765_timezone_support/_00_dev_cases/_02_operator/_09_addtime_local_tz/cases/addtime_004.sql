--TEST: pass different formats of string arguments to the 2nd parameter


--TEST: 1. string values of date format
select addtime(timestampltz'2011-10-26 14:59:59', '2010-10-08');

--TEST: ?? date without year, it returns null in mysql
select addtime(timestampltz'2011-10-26 14:59:59', '1900-12-25');

select addtime(timestampltz'2011-10-26 14:59:59', '8/30/12');

select addtime(timestampltz'2011-10-26 14:59:59', '1864/11/09');



--TEST: 2. string values of timestampltz format
select addtime(timestampltz'2011-10-26 14:59:59', '13:14:55 10/08/01');

select addtime(timestampltz'2011-10-26 14:59:59', '2:22:22 8/12/2010');

select addtime(timestampltz'2011-10-26 14:59:59', '09:03:22 PM 1988-08-08');

select addtime(timestampltz'2011-10-26 14:59:59', '12/12/2022 10:20:55');



--TEST: 3. string values of datetimeltz format
select addtime(timestampltz'2011-10-26 14:59:59', '10/08/01 13:14:55.123');

select addtime(timestampltz'2011-10-26 14:59:59', '2010-8-12 2:22:22.333');

select addtime(timestampltz'2011-10-26 14:59:59', '1988-08-08 09:03:22.012');

select addtime(timestampltz'2011-10-26 14:59:59', '1556/12/12 10:20:55.567');



--TEST: 4. string values of timeltz format
select addtime(timestampltz'2011-10-26 14:59:59', '13:14:55');

select addtime(timestampltz'2011-10-26 14:59:59', '2:22:22');

select addtime(timestampltz'2011-10-26 14:59:59', '09:03:22.012');

select addtime(timestampltz'2011-10-26 14:59:59', '10:20:55.567');

