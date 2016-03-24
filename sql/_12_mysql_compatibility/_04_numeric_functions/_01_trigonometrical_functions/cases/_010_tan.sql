SELECT to_char(TAN(cast(PI() as integer)),'9.999EEEE') FROM db_root;

SELECT TAN(PI()+1) FROM db_root;

SELECT cast(TAN(3.14) as numeric(6,5)) FROM db_root;

SELECT TAN('3.14') FROM db_root;

SELECT TAN('a') FROM db_root;

SELECT TAN(NULL) FROM db_root;

select cast(tan(123456789012345.12345) as numeric(6,5)) from db_root;
