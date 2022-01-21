SELECT 1 from db_root where ISNULL(1+1)<>0;

SELECT 1 from db_root where ISNULL(1/0)<>0;

SELECT 1 from db_root where ISNULL(NULL)<>0;

SELECT 1 from db_root where ISNULL('2')<>0;

SELECT 1 from db_root where ISNULL(1)<>0;

SELECT 1 from db_root where ISNULL('1'+'1')<>0;

select 1 from db_root where isnull(123456789012345/1234567890)<>0;
