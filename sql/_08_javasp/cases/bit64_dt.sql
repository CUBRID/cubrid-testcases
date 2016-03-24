-- sp for datetime

CREATE FUNCTION parseDatetime(i in string) return DATETIME as language java name 'SpTest4bit64.parseDatetime(java.lang.String) return java.util.Timestamp';
call parseDatetime('2009-01-01 12:30:00.999');

CREATE FUNCTION newDatetime(yy int, mm int, dd int, hh int, mi int, ss int, ms int) return DATETIME as language java name 'SpTest4bit64.newDatetime(int, int, int, int, int, int, int) return java.util.Timestamp';
call newDatetime(2009, 3, 4, 5, 6, 7, 888);
 
CREATE FUNCTION addMonths(dt DATETIME, n int) return DATETIME as language java name 'SpTest4bit64.addMonths(java.sql.Timestamp, int) return java.util.Timestamp';
call addMonths(Datetime '2009-02-01 12:30:00.777', 3);


CREATE PROCEDURE incrementMonth(dt in out DATETIME) as language java name 'SpTest4bit64.incrementMonth(java.sql.Timestamp[])';
call incrementMonth(Datetime '2009-02-01 12:30:00.777');
evaluate Datetime '2009-02-01 12:30:00.777'  to x;
call incrementMonth(x);
evaluate x;

DROP FUNCTION parseDatetime;
DROP FUNCTION newDatetime;
DROP FUNCTION addMonths;
DROP PROCEDURE incrementMonth;

