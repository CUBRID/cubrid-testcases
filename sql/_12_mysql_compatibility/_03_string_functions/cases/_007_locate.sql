SELECT LOCATE('bar', 'foobarbar') from db_root;

SELECT LOCATE(NULL, 'foobarbar') from db_root;

SELECT LOCATE(1, 'foobarbar') from db_root;

SELECT LOCATE(1, 123) from db_root;

SELECT LOCATE('1', 123) from db_root;

SELECT LOCATE('bar', NULL) from db_root;

SELECT LOCATE(NULL, NULL) from db_root;

SELECT LOCATE('xbar', 'foobar') from db_root;

SELECT LOCATE('bar', 'foobarbar', 5) from db_root;
