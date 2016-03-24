SELECT COT(12) from db_root;

SELECT COT(0) from db_root;

SELECT COT('12') from db_root;

SELECT COT('a') from db_root;

SELECT COT(NULL) from db_root;

select cast(cot(123456789012345.12345) as numeric(6,5)) from db_root;
