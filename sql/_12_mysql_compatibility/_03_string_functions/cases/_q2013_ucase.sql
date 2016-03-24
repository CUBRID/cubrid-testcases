SELECT UCASE(_utf8'중국이다,i''m chinese!') from db_root;
SELECT UCASE('~!@#$%^&*()_+|''\=-,./') from db_root;
SELECT UCASE(CONCAT_WS(1,2,3,4,5,6,7,8,9)) FROM DB_ROOT;
SELECT UCASE(CONCAT_WS('a','b','c','d','e','f')) FROM DB_ROOT;
SELECT UCASE(CONCAT('a','b','c','d','e','f')) FROM DB_ROOT;
SELECT FIELD(UCASE(CONCAT('A','b','c','d','e','f')),'aBCDEF',
				UCASE(CONCAT_ws('ABCd','E','f')),
				UCASE(CONCAT('ABCd','E','f'))) FROM DB_ROOT;
select concat_ws(UCASE(concat('s',600)),UCASE('mmm'),2<<3);
select concat_ws(UCASE(concat('s',600)),UCASE('mmm'),char_length(UCASE('aa'))<<char_length('abc'));