SELECT LOCATE(1, 21) from db_root;
SELECT LOCATE('bar', 'foobarbar', 4+1) from db_root;
SELECT LOCATE('bar', 'foobarbar', 5) from db_root;
SELECT LOCATE('bar', 'foobarbar', 2000000000) from db_root;
SELECT LOCATE('bar', 'foobarbar', 1999999999) from db_root;
SELECT LOCATE('bar', 'foobarbar', 1999999999+1) from db_root;

SELECT LOCATE(left('중국abc이다',3), 'III중국abc이다') from db_root;
SELECT LOCATE(left('중국abc이다',1+2), concat_ws('국ab','III중','c')) from db_root;