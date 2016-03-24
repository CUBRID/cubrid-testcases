SELECT 1 from db_root where 1 <=> 1;
SELECT 1 from db_root where  NULL <=> NULL;
SELECT 1 from db_root where 1 <=> NULL;

SELECT 1 from db_root where '1' <=> 1;
SELECT 1 from db_root where '1' <=> '1';
SELECT 1 from db_root where  '1' <=> NULL;

SELECT 1 from db_root where 1 = 1;
SELECT 1 from db_root where NULL = NULL;
SELECT 1 from db_root where 1 = NULL;

SELECT 1 from db_root where '1' = 1;
SELECT 1 from db_root where '1' = '1';
SELECT 1 from db_root where 1 = NULL;

SELECT 1 from db_root where 123456789012345 <=> 1283241243123;

SELECT 1 from db_root where 123456789012345 <=> null;
