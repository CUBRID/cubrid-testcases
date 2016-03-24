SELECT FORMAT(12332.123456, 4) from db_root;

SELECT FORMAT(12332.1,4) from db_root;

SELECT FORMAT(12332.2,0) from db_root;

SELECT FORMAT('12332.123456', 4) from db_root;

SELECT FORMAT('12332.1','4') from db_root;

SELECT FORMAT('12332.1','a') from db_root;

SELECT FORMAT(NULL,4) from db_root;

SELECT FORMAT(12332.1,NULL) from db_root;

SELECT FORMAT('a',0) from db_root;

select format(123456789012345.12346,4) from db_root;
