SELECT COS(PI()) from db_root;

SELECT to_char(cos(2), '9.999999') from db_root;

SELECT to_char(cos('1'), '9.999999') from db_root;

SELECT COS('a') from db_root;

SELECT COS(NULL) from db_root;

select cast(cos(123456789012345.12345) as numeric(6,5)) from db_root;
