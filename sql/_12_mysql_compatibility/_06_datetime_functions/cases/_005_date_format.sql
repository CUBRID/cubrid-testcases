SELECT DATE_FORMAT('2009-10-04 22:23:00', '%W %M %Y') from db_root;

SELECT DATE_FORMAT('2007-10-04 22:23:00', '%H:%i:%s') from db_root;

SELECT DATE_FORMAT('1900-10-04 22:23:00','%D %y %a %d %m %b %j') from db_root;

SELECT DATE_FORMAT('1997-10-04 22:23:00','%H %k %I %r %T %S %w') from db_root;

SELECT DATE_FORMAT('1999-01-01', '%X %V') from db_root;

SELECT DATE_FORMAT('2006-06-00', '%d') from db_root;

SELECT DATE_FORMAT('2003-10-03',GET_FORMAT(DATE,'EUR'));

SELECT STR_TO_DATE('10.31.2003',GET_FORMAT(DATE,'USA'));