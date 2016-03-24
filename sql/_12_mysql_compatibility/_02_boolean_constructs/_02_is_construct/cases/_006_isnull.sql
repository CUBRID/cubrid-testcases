SELECT 1 from db_root where ISNULL(1+1);

SELECT 1 from db_root where ISNULL(1/0);

SELECT 1 from db_root where ISNULL(NULL);

SELECT 1 from db_root where ISNULL('2');

SELECT 1 from db_root where ISNULL(1);

SELECT 1 from db_root where ISNULL('1'+'1');

select 1 from db_root where isnull(123456789012345/1234567890);