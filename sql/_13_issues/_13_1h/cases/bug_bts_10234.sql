select pow('a', null);

select mod('a', null);

select mod('a', null);

select abs(null);

select abs(abs(null));

select ASIN(null  + null);

select DEGREES (null);

select EXP(null);

select * from (select EXP(null));

select ROUND('a' ,null);

select ROUND('null' ,null);

select ROUND(-34567.34567 ,null);

select ROUND(null,null);

select ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null),ROUND(null,null);

SELECT TRUNC(34567.34567, null), TRUNC(-34567.34567, null);

SELECT TRUNC(null, null), TRUNC(-34567.34567, null);

SELECT TRUNC(null, null), TRUNC(null, -1);

SELECT (TRUNC(null, null)) ||  (TRUNC(-34567.34567, null));

SELECT (TRUNC(null, null)) ||  (TRUNC(-34567.34567, null) ||  (TRUNC(null, null)) ||  (TRUNC(-34567.34567, null)) ||  (TRUNC(-34567.34567, null)));

SELECT ADDDATE('0001-01-01 00:00:00', null);

SELECT ADDDATE('null', NULL);

SELECT ADDDATE('0001-01-01 00:00:00', null) ;

SELECT ADDDATE('0001-01-01 00:00:00', null);

SELECT ADDDATE(null, 1);

SELECT DATE '2008-12-25'+null;

SELECT SECOND('2010-01-01 12:34:56.7890') + null;

SELECT SEC_TO_TIME(null);

SELECT TIMEDIFF('17:18:19',null);

SELECT TIMEDIFF(null, '2010-01-01 03:04:05');

SELECT TIMEDIFF(null, '2010-01-01 03:04:05'),TIMEDIFF(null, null) || TIMEDIFF(null, null);

SELECT TIMEDIFF(null, 'null');

SELECT TIMEDIFF('null', 'null');

