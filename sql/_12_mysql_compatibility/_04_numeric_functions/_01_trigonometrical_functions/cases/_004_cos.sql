SELECT COS(PI()) from db_root;

SELECT COS(2) from db_root;

SELECT COS('1') from db_root;

SELECT COS('a') from db_root;

SELECT COS(NULL) from db_root;

select cast(cos(123456789012345.12345) as numeric(6,5)) from db_root;
