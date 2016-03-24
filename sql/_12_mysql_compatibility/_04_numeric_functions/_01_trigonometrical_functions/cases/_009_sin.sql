SELECT SIN(0) FROM db_root;

SELECT ROUND(SIN(1)) FROM db_root;

SELECT SIN('0') FROM db_root;

SELECT SIN('a') FROM db_root;

SELECT SIN(NULL) FROM db_root;

select cast(sin(123456789012345.12345) as numeric(6,5)) from db_root;
