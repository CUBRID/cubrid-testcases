SELECT 1 from db_root where  '.01' <> '0.01';

SELECT 1 from db_root where .01 <> '0.01';

SELECT 1 from db_root where NULL <> '0.01';

SELECT 1 from db_root where NULL <> 0.01;

SELECT 1 from db_root where NULL <> 'foo';

SELECT 1 from db_root where 'zapp' <> 'zappp';

SELECT 1 from db_root where 123456789012345 <> 1283241243123;

SELECT 1 from db_root where '.01' != '0.01';

SELECT 1 from db_root where .01 != '0.01';

SELECT 1 from db_root where NULL != '0.01';

SELECT 1 from db_root where NULL != 0.01;

SELECT 1 from db_root where NULL != 'foo';

SELECT 1 from db_root where 'zapp' != 'zappp';

SELECT 1 from db_root where 123456789012345 != 1283241243123;