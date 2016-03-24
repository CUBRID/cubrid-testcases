select 1 from db_root where 1 IS NOT UNKNOWN;
select 1 from db_root where 0 IS NOT UNKNOWN;
select 1 from db_root where 'a' IS NOT UNKNOWN;
select 1 from db_root where NULL IS NOT UNKNOWN;
select 1 from db_root where 123456789012345 is not unknown;