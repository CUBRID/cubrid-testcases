SELECT LCASE(_utf8'중국이다,I''M Chinese!') from db_root;
SELECT LCASE('~!@#$%^&*()_+|''\=-,./') from db_root;
SELECT LCASE(CONCAT_WS(1,2,3,4,5,6,7,8,9)) FROM DB_ROOT;
SELECT LCASE(CONCAT_WS('A','b','c','d','e','f')) FROM DB_ROOT;
SELECT LCASE(CONCAT('A','b','c','d','e','f')) FROM DB_ROOT;
SELECT FIELD(LCASE(CONCAT('A','b','c','d','e','f')),'ABCDEF',
				LCASE(CONCAT_ws('ABCd','E','f')),
				LCASE(CONCAT('ABCd','E','f'))) FROM DB_ROOT;
select concat_ws(lcase(concat('S',600)),lcase('MMM'),2<<3);
select concat_ws(lcase(concat('S',600)),lcase('MMM'),char_length(lcase('AA'))<<char_length('abc'));