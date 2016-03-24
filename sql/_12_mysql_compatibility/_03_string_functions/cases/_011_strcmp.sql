SELECT STRCMP('text', 'text2') FROM db_root;

SELECT STRCMP(123, 'text2') FROM db_root;

SELECT STRCMP('text', 123) FROM db_root;

SELECT STRCMP(NULL, 'text2') FROM db_root;

SELECT STRCMP(123, NULL) FROM db_root;

SELECT STRCMP(NULL, NULL) FROM db_root;
